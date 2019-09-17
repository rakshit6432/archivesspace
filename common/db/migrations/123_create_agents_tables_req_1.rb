require_relative 'utils'

Sequel.migration do

  up do
    create_table(:agent_record_control) do
      primary_key :id

      Integer :maintenance_status_enum_id, :null => false
      Integer :publication_status_enum_id, :null => true
      Integer :romanization_enum_id, :null => true
      Integer :government_agency_type_enum_id, :null => true
      Integer :reference_evaluation_enum_id, :null => true
      Integer :name_type_enum_id, :null => true
      Integer :level_of_detail_enum_id, :null => true
      Integer :modified_record_enum_id, :null => true
      Integer :cataloging_source_enum_id, :null => true

      String :maintenance_agency, :null => true
      String :agency_name, :null => true
      String :maintenance_agency_note, :null => true
      String :language, :null => false
      String :script, :null => true
      String :language_note, :null => true

      Integer :agent_person_id, :null => true
      Integer :agent_family_id, :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:agent_alternate_set) do
      primary_key :id

      Integer :file_version_xlink_actuate_attribute_id, :null => true
      Integer :file_version_xlink_show_attribute_id, :null => true

      String :set_component, :null => true
      String :descriptive_note, :null => true
      String :file_uri, :null => true
      String :xlink_title_attribute, :null => true
      String :xlink_role_attribute, :null => true
      DateTime :last_verified_date, :null => true

      Integer :agent_person_id, :null => true
      Integer :agent_family_id, :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:agent_conventions_declaration) do
      primary_key :id

      Integer :name_rule_id, :null => false
      Integer :file_version_xlink_actuate_attribute_id, :null => true
      Integer :file_version_xlink_show_attribute_id, :null => true

      String :citation, :null => false
      String :descriptive_note, :null => false
      String :file_uri, :null => true
      String :xlink_title_attribute, :null => true
      String :xlink_role_attribute, :null => true
      DateTime :last_verified_date, :null => true

      Integer :agent_person_id, :null => true
      Integer :agent_family_id, :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:agent_other_agency_codes) do
      primary_key :id

      Integer :agency_code_type_enum_id, :null => false

      String :maintenance_agency, :null => false

      Integer :agent_person_id, :null => true
      Integer :agent_family_id, :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:agent_maintenance_history) do
      primary_key :id

      Integer :maintenance_event_type_enum_id, :null => false
      Integer :maintenance_agent_type_enum_id, :null => false

      DateTime :event_date, :null => false
      String :agent, :null => false
      String :descriptive_note, :null => false

      Integer :agent_person_id, :null => true
      Integer :agent_family_id, :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:agent_record_identifier) do
      primary_key :id

      Integer :identifier_type_enum_id, :null => false
      Integer :source_enum_id, :null => false

      Integer :primary_identifier, :null => false

      String :record_identifier, :null => false

      Integer :agent_person_id, :null => true
      Integer :agent_family_id, :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:agent_sources) do
      primary_key :id
      
      String :source_entry, :null => true
      String :descriptive_note, :null => true
      String :file_uri, :null => true
      Integer :file_version_xlink_actuate_attribute_id, :null => true
      Integer :file_version_xlink_show_attribute_id, :null => true

      String :xlink_title_attribute, :null => true
      String :xlink_role_attribute, :null => true
      
      DateTime :last_verified_date, :null => true
      
      Integer :agent_person_id, :null => true
      Integer :agent_family_id, :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end
  end
end