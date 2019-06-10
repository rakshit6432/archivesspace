class StructuredDate < Sequel::Model(:structured_date)
  include ASModel

  corresponds_to JSONModel(:structured_date)

  set_model_scope :global
end

