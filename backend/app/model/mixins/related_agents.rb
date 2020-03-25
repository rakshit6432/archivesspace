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
  end


  # When saving/loading this relationship, link up and fetch a nested date
  # record to capture the dates.
  def self.set_up_date_record_handling(relationship_clz)
    relationship_clz.instance_eval do
      extend JSONModel
      include ASModel
      include ASModel::SequelHooks

      one_to_one :date, :class => "StructuredDateLabel", :key => :related_agents_rlshp_id

      #def_nested_record(:the_property => :relationship_date,
      #                  :contains_records_of_type => :structured_date_label,
      #                  :corresponding_to_association => :structured_date_label)

      one_to_one :subject, :class => "Subject", :key => :related_agents_rlshp_id

      def_nested_record(:the_property => :place,
                        :contains_records_of_type => :subject,
                        :corresponding_to_association => :subject)

      # FAILS WITH: (Unknown response: {"error":"method places= doesn't exist: /Users/manny/Dropbox/code/macCode/LibraryHost/archivesspace/build/gems/gems/sequel-4.20.0/lib/sequel/model/base.rb:2138


      #define_relationship(:name => :subject_related_agents_rlshp_place,
                          #:json_property => 'places',
                          #:contains_references_to_types => proc {[Subject]})


      def self.create(values)
        date_values = values.delete('dates')
        obj = super

        if date_values
          date = StructuredDateLabel.create_from_json(JSONModel(:structured_date_label).from_hash(date_values))
          obj.date = date
          obj.save
        end

        obj
      end


      alias_method :delete_orig, :delete
      define_method(:delete) do
        date.delete if date
        delete_orig
      end


      alias_method :values_orig, :values
      define_method(:values) do
        result = values_orig

        if self.date
          result['date'] = StructuredDateLabel.to_jsonmodel(self.date).to_hash
        end

        result
      end
    end
  end

end
