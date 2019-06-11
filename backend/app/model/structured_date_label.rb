class StructuredDateLabel < Sequel::Model(:structured_date_label)
  include ASModel

  corresponds_to JSONModel(:structured_date_label)

  set_model_scope :global

  one_to_many :structured_dates, :class => "StructuredDate"

  def_nested_record(:the_property => :structured_dates,
                    :contains_records_of_type => :structured_date,
                    :corresponding_to_association => :structured_dates)



end

