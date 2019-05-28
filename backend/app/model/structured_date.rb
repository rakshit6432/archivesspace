class StructuredDate < Sequel::Model(:structured_date)
  include ASModel

  corresponds_to JSONModel(:structured_date)

  set_model_scope :global

  def validate
    validates_presence(:date_role_enum, :message => "Single dates must have a role")

    has_expr_date = !self.date_expression.nil? && 
                    !self.date_expression.empty?

    has_std_date = !self.date_standardized.nil? 

    errors.add(:base, "A date or date expression is required") unless has_expr_date || has_std_date
  end
end

