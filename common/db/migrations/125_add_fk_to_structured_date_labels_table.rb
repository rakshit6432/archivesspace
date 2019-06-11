require_relative 'utils'

Sequel.migration do

  up do
    alter_table(:structured_date_label) do
      # for dates of existence
      add_column(:agent_person_id, Integer, :null => true)
      add_column(:agent_family_id, Integer, :null => true)
      add_column(:agent_corporate_entity_id, Integer, :null => true)
      add_column(:agent_software_id, Integer, :null => true)

      # for dates of name use
      add_column(:name_person_id, Integer, :null => true)
      add_column(:name_family_id, Integer, :null => true)
      add_column(:name_corporate_entity_id, Integer, :null => true)
      add_column(:name_software_id, Integer, :null => true)

      # for agent relationship dates        
      add_column(:related_agents_rlshp_id, Integer, :null => true)
    end
  end
end