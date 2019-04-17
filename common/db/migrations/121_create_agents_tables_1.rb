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

      String :maintenence_agency, :null => true
      String :agency_name, :null => true
      String :maintenence_agency_note, :null => true
      String :language, :null => false
      String :script, :null => true
      String :language_note, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:agent_alternate_set) do
      Integer :file_version_xlink_actuate_attribute_enum_id, :null => true
      Integer :file_version_xlink_show_attribute_enum_id, :null => true

      String :set_component, :null => true
      String :descriptive_note, :null => true
      String :file_uri, :null => true
      String :xlink_title_attribute, :null => true
      String :xlink_role_attribute, :null => true
      DateTime :last_verified_date, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:agent_conventions_declaration) do
      Integer :convention_enum_id, :null => false

      String :citation, :null => false
      String :descriptive_note, :null => false
      String :file_uri, :null => true
      Integer :file_version_xlink_actuate_attribute_enum_id, :null => true
      Integer :file_version_xlink_show_attribute_enum_id, :null => true
      String :xlink_title_attribute, :null => true
      String :xlink_role_attribute, :null => true
      DateTime :last_verified_date, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:agent_other_agency_codes) do
      Integer :agency_code_type_enum_id, :null => false

      String :maintenence_agency, :null => false

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:agent_maintenence_history) do
      Integer :maintenence_event_type_enum_id, :null => false
      Integer :maintenence_agent_type_enum_id, :null => false

      DateTime :event_date, :null => false
      String :agent, :null => false
      String :descriptive_note, :null => false

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:agent_record_identifier) do
      Integer :identifier_type_enum_id, :null => false
      Integer :source_enum_id, :null => false

      Integer :primary_identifier, :null => false

      String :record_identifier, :null => false

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:agent_sources) do
      String :source_entry, :null => true
      String :descriptive_note, :null => true
      String :file_uri, :null => true
      Integer :file_version_xlink_actuate_attribute_enum_id, :null => true
      Integer :file_version_xlink_show_attribute_enum_id, :null => true
      String :xlink_title_attribute, :null => true
      String :xlink_role_attribute, :null => true
      
      DateTime :last_verified_date, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end
  end
end