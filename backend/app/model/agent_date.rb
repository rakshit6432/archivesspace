class AgentDate < Sequel::Model(:agent_date)
  include ASModel

  corresponds_to JSONModel(:agent_date)

  set_model_scope :global

  def validate
  end 
end

