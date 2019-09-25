class AgentRecordControl < Sequel::Model(:agent_record_control)
  include ASModel
  include AgentSubrecords
  include LangMaterials
  
  corresponds_to JSONModel(:agent_record_control)

  set_model_scope :global

  # validations:
  # must be linked to one agent type

  def validate
    validate_agent_defined
    validates_unique(:agent_person_id, :message => "Must point to a unique AgentPerson")
    validates_unique(:agent_family_id, :message => "Must point to a unique AgentFamily")
    validates_unique(:agent_corporate_entity_id, :message => "Must point to a unique AgentCorporateEntity")
    validates_unique(:agent_software_id, :message => "Must point to a unique AgentSoftware")
    super
  end

  
end

