class StructuredDateLabel < Sequel::Model(:structured_date_label)
  include ASModel

  corresponds_to JSONModel(:structured_date_label)

  set_model_scope :global

  one_to_many :structured_dates, :class => "StructuredDate"

  def_nested_record(:the_property => :structured_dates,
                    :contains_records_of_type => :structured_date,
                    :corresponding_to_association => :structured_dates)


#  define_relationship(:name => :structured_date_agent,
#                      :json_property => 'linked_records',
#                      :contains_references_to_types => proc {[Accession, Resource]})
      
  plugin :nested_attributes
  nested_attributes :structured_dates
end

