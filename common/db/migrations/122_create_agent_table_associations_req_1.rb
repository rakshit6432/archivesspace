require_relative 'utils'

Sequel.migration do

  up do
    alter_table(:agent_record_control) do
      add_column(:agent_person_id, Integer)
      add_column(:agent_family_id, Integer)
      add_column(:agent_corporate_entity_id, Integer)
      add_column(:agent_software_id, Integer)
    end

    alter_table(:agent_alternate_set) do
      add_column(:agent_person_id, Integer)
      add_column(:agent_family_id, Integer)
      add_column(:agent_corporate_entity_id, Integer)
      add_column(:agent_software_id, Integer)
    end

    alter_table(:agent_conventions_declaration) do
      add_column(:agent_person_id, Integer)
      add_column(:agent_family_id, Integer)
      add_column(:agent_corporate_entity_id, Integer)
      add_column(:agent_software_id, Integer)
    end

    alter_table(:agent_other_agency_codes) do
      add_column(:agent_person_id, Integer)
      add_column(:agent_family_id, Integer)
      add_column(:agent_corporate_entity_id, Integer)
      add_column(:agent_software_id, Integer)
    end

    alter_table(:agent_maintenance_history) do
      add_column(:agent_person_id, Integer)
      add_column(:agent_family_id, Integer)
      add_column(:agent_corporate_entity_id, Integer)
      add_column(:agent_software_id, Integer)
    end

    alter_table(:agent_record_identifier) do
      add_column(:agent_person_id, Integer)
      add_column(:agent_family_id, Integer)
      add_column(:agent_corporate_entity_id, Integer)
      add_column(:agent_software_id, Integer)
    end

    alter_table(:agent_sources) do
      add_column(:agent_person_id, Integer)
      add_column(:agent_family_id, Integer)
      add_column(:agent_corporate_entity_id, Integer)
      add_column(:agent_software_id, Integer)
    end
  end
end