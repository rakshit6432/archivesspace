class StructuredDateRange < Sequel::Model(:structured_date_range)
  include ASModel

  corresponds_to JSONModel(:structured_date_range)

  set_model_scope :global
end

