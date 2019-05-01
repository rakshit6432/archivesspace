require_relative 'utils'

Sequel.migration do

  up do
    alter_table(:agent_record_control) do
      add_column(:agent_person_id, Integer)
      add_column(:agent_family_id, Integer)
      add_column(:agent_corporate_entity_id, Integer)
      add_column(:agent_software_id, Integer)
    end

    create_table(:agent_alternate_set_rlshp) do
      Integer :agent_person_id,           :null => true
      Integer :agent_family_id,           :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id,         :null => true

      Integer :agent_alternate_set_id, :null => false
    end

    create_table(:agent_conventions_declaration_rlshp) do
      Integer :agent_person_id,           :null => true
      Integer :agent_family_id,           :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id,         :null => true

      Integer :agent_conventions_declaration_id, :null => false
    end

    create_table(:agent_other_agency_codes_rlshp) do
      Integer :agent_person_id,           :null => true
      Integer :agent_family_id,           :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id,         :null => true

      Integer :agent_other_agency_codes_id, :null => false
    end

    create_table(:agent_maintenance_history_rlshp) do
      Integer :agent_person_id,           :null => true
      Integer :agent_family_id,           :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id,         :null => true

      Integer :agent_maintenance_history_id, :null => false
    end

    create_table(:agent_record_identifier_rlshp) do
      Integer :agent_person_id,           :null => true
      Integer :agent_family_id,           :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id,         :null => true

      Integer :agent_record_identifier_id, :null => false
    end

    create_table(:agent_sources_rlshp) do
      Integer :agent_person_id,           :null => true
      Integer :agent_family_id,           :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id,         :null => true

      Integer :agent_sources_id, :null => false
    end
  end
end