class StructuredDateSingle < Sequel::Model(:structured_date_single)
  include ASModel

  corresponds_to JSONModel(:structured_date_single)

  set_model_scope :global
end

