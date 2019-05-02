class AgentRecordControl < Sequel::Model(:agent_record_control)
  include ASModel
  corresponds_to JSONModel(:agent_record_control)

  set_model_scope :global

  one_to_one :agent_person
  one_to_one :agent_family
  one_to_one :agent_corporate_entity
  one_to_one :agent_software

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

  def validate_agent_defined
    agents_defined = 0
    agents_defined += 1 unless self.agent_person_id.nil?
    agents_defined += 1 unless self.agent_family_id.nil?
    agents_defined += 1 unless self.agent_corporate_entity_id.nil?
    agents_defined += 1 unless self.agent_software_id.nil?

    unless agents_defined == 1
      errors.add(:base, 'Exactly one agent type must be defined.') 
    end
  end  
end

