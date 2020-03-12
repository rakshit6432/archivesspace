require_relative 'directional_relationships'

module RelatedAgents
  extend JSONModel

  def self.included(base)
    callback = proc { |clz| RelatedAgents.set_up_date_record_handling(clz) }

    base.include(DirectionalRelationships)

    base.define_directional_relationship(:name => :related_agents,
                                         :json_property => 'related_agents',
                                         :contains_references_to_types => proc {
                                           AgentManager.registered_agents.map {|a| a[:model]}
                                         },
                                         :class_callback => callback)

    # This likely won't work -- All other agent links in system are done with relationships, not a one-to-many. TODO: figure out if this is worth looking into and what the impact would be.
    #base.one_to_many :subject
    #base.def_nested_record(:the_property => :places,
    #                       :contains_records_of_type => :subject,
    #                       :corresponding_to_association => :subject)

    # This seems to be the same as adding the define_relationship code to all the relationship e.g., (AgentRelationshipParentchild, etc)models, since they all include this module.
    # FAILS WITH: (Unknown response: {"error":"method places= doesn't exist: /Users/manny/Dropbox/code/macCode/LibraryHost/archivesspace/build/gems/gems/sequel-4.20.0/lib/sequel/model/base.rb:2138
    # in frontend during to CRUD operation
    # Not sure where a definition for places= is missing, since it's defined in the abstract schema for all relationship JSONmodels. 
    # It doesn't make sense that it's expected to be defined in the DB somewhere as a field.
    #base.define_relationship(:name => :subject,
                             #:json_property => 'places',
                             #:contains_references_to_types => proc {[Subject]})
  end


  # When saving/loading this relationship, link up and fetch a nested date
  # record to capture the dates.
  def self.set_up_date_record_handling(relationship_clz)
    relationship_clz.instance_eval do
      extend JSONModel
      one_to_one :relationship_date, :class => "StructuredDateLabel", :key => :related_agents_rlshp_id

      include ASModel::SequelHooks

      # FAILS WITH:  NameError: wrong constant name Relationships::AgentCorporateEntityRelatedAgentsSubject

      #define_relationship(:name => :subject_related_agents_rlshp_place,
      #                    :json_property => 'places',
      #                    :contains_references_to_types => proc {[Subject]})


      def self.create(values)
        date_values = values.delete('dates')
        obj = super

        if date_values
          date = StructuredDateLabel.create_from_json(JSONModel(:structured_date_label).from_hash(date_values))
          obj.relationship_date = date
          obj.save
        end

        obj
      end


      alias_method :delete_orig, :delete
      define_method(:delete) do
        relationship_date.delete if relationship_date
        delete_orig
      end


      alias_method :values_orig, :values
      define_method(:values) do
        result = values_orig

        if self.relationship_date
          result['dates'] = StructuredDateLabel.to_jsonmodel(self.relationship_date).to_hash
        end

        result
      end
    end
  end

end
