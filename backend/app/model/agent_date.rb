class AgentDate < Sequel::Model(:agent_date)
  include ASModel

  corresponds_to JSONModel(:agent_date)

  set_model_scope :global

  def validate
		if self.date_type_enum == "single"
			validate_single_date
		elsif self.date_type_enum == "range"
			validate_ranged_date
		end
  end 

  private

  # single dates
  # must specify role
  # if role is begin, begin date of either type must be specified
  # if role is end, end date of either type must be specified
  # must not have both begin and end specified
  def validate_single_date
  	validates_presence(:date_role_enum, :message => "Single dates must have a role")

  	if self.date_role_enum == "begin"
  		has_expr_date = !self.begin_date_expression.nil? && 
  									  !self.begin_date_expression.empty?

  		has_std_date = !self.begin_date_standardized.nil? 

  		msg = "Begin date required"
  	elsif self.date_role_enum == "end"
  		has_expr_date = !self.end_date_expression.nil? && 
  									  !self.end_date_expression.empty?

  		has_std_date = !self.end_date_standardized.nil?

  		msg = "End date required"
  	end

  	errors.add(:base, msg) unless has_expr_date || has_std_date
  end


  # range dates
  # both begin and end must be specified (either type)
  def validate_ranged_date
 		has_begin_date = (!self.begin_date_expression.nil? && 
 							 		   !self.begin_date_expression.empty?) ||
								  	 !self.begin_date_standardized.nil? 


 		has_end_date = (!self.end_date_expression.nil? && 
 						  		  !self.end_date_expression.empty?) ||
								  	!self.end_date_standardized.nil? 


 		msg = "Begin and end dates required for ranged dates"
  	errors.add(:base, msg) unless has_begin_date && has_end_date
  end

end

