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

  def validate
    count = self.structured_dates.length

    begin_dates = self.structured_dates.select {|date| date.date_role_enum == "begin"}
    end_dates = self.structured_dates.select {|date| date.date_role_enum == "end"}

    has_begin = begin_dates.length > 0
    has_end = end_dates.length > 0

    if self.date_type_enum == "single"
      errors.add(:base, "At lease one start date subrecord is required for single dates") unless has_begin
      errors.add(:base, "Single dates should not have end date subrecord") if has_end
    elsif self.date_type_enum == "range"
      errors.add(:base, "Ranged dates require begin and end dates") unless has_end && has_begin

      # check that no standardized begin date is chronologically after any standardized end date
      begin_dates.select! {|d| d.date_standardized}
      end_dates.select!   {|d| d.date_standardized}

      begin_dates.map! {|d| Time.parse(d.date_standardized)}
      end_dates.map!   {|d| Time.parse(d.date_standardized)}

      out_of_order = false
      begin_dates.each do |bd|
        end_dates.each do |ed|
          out_of_order = bd > ed

          break if out_of_order
        end

        break if out_of_order
      end

      errors.add(:base, "Begin dates must be later than end dates") if out_of_order
    end
  end 
end

