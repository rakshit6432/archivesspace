class StructuredDateLabel < Sequel::Model(:structured_date_label)
  include ASModel

  corresponds_to JSONModel(:structured_date_label)

  set_model_scope :global

  one_to_many :structured_dates, :class => "StructuredDate"

  def_nested_record(:the_property => :structured_dates,
                    :contains_records_of_type => :structured_date,
                    :corresponding_to_association => :structured_dates)
      
  plugin :nested_attributes
  nested_attributes :structured_dates

  def validate
    count = self.structured_dates.length

    if self.date_type_enum == "single"
      errors.add(:base, "One date subrecord is required for single dates") unless count == 1
    elsif self.date_type_enum == "range"
      errors.add(:base, "Two date subrecords are required for ranged dates") unless count == 2

      has_begin = self.structured_dates.inject(false) {|carry, date| carry || date.date_role_enum == "begin"}
      has_end = self.structured_dates.inject(false) {|carry, date| carry || date.date_role_enum == "end"}

      errors.add(:base, "Ranged dates require begin and end dates") unless has_end && has_begin
    end
  end 
end

