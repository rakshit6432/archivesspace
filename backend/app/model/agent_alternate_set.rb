class AgentAlternateSet < Sequel::Model(:agent_alternate_set)
  include ASModel
  corresponds_to JSONModel(:agent_alternate_set)

  set_model_scope :global

  #TODO: Add validations
  
end

