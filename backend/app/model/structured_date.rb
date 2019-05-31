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

    if has_std_date
      matches_y       = (self.date_standardized =~ /^[\d]{1}$/) == 0
      matches_y_mm       = (self.date_standardized =~ /^[\d]{1}-[\d]{2}$/) == 0
      matches_yy       = (self.date_standardized =~ /^[\d]{2}$/) == 0
      matches_yy_mm       = (self.date_standardized =~ /^[\d]{2}-[\d]{2}$/) == 0
      matches_yyy       = (self.date_standardized =~ /^[\d]{3}$/) == 0
      matches_yyy_mm       = (self.date_standardized =~ /^[\d]{3}-[\d]{2}$/) == 0
      matches_yyyy       = (self.date_standardized =~ /^[\d]{4}$/) == 0
      matches_yyyy_mm    = (self.date_standardized =~ /^[\d]{4}-[\d]{2}$/) == 0
      matches_yyyy_mm_dd = (self.date_standardized =~ /^[\d]{4}-[\d]{2}-[\d]{2}$/) == 0
      matches_mm_yyyy     = (self.date_standardized =~ /^[\d]{2}-[\d]{4}$/) == 0
      matches_mm_dd_yyyy = (self.date_standardized =~ /^[\d]{4}-[\d]{2}-[\d]{2}$/) == 0

      errors.add(:base, "Standardized dates must be in YYYY[YYY][YY][Y], YYYY[YYY][YY][Y]-MM, or YYYY-MM-DD format") unless matches_yyyy || matches_yyyy_mm || matches_yyyy_mm_dd || matches_yyy || matches_yy || matches_y || matches_yyy_mm || matches_yy_mm || matches_y_mm || matches_mm_yyyy || matches_mm_dd_yyyy

      
    end
  end
end

