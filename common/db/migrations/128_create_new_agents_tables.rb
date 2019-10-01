require_relative 'utils'

Sequel.migration do

  up do
    $stderr.puts "Creating new database tables for new agents functionality"
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

    date_std_type_id = get_enum_value_id("date_standardized_type_enum", "standard")

    create_table(:structured_date_single) do
      primary_key :id
      Integer :structured_date_label_id, :null => false

      Integer :date_role_enum_id, :null => false
      String :date_expression, :null => true
      String :date_standardized, :null => true
      Integer :date_standardized_type_enum_id, :null => false, :default => date_std_type_id

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:structured_date_range) do
      primary_key :id
      Integer :structured_date_label_id, :null => false

      String :begin_date_expression, :null => true
      String :begin_date_standardized, :null => true
      Integer :begin_date_standardized_type_enum_id, :null => false, :default => date_std_type_id

      String :end_date_expression, :null => true
      String :end_date_standardized, :null => true
      Integer :end_date_standardized_type_enum_id, :null => false, :default => date_std_type_id

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:structured_date_label) do
      primary_key :id

      Integer :date_label_id, :null => false # existing enum date_label
      Integer :date_type_enum_id, :null => false
      Integer :date_certainty_id, :null => true # existing enum date_certainty
      Integer :date_era_id, :null => true # existing enum date_era
      Integer :date_calendar_id, :null => true # existing enum date_calendar

      Integer :agent_person_id, :null => true 
      Integer :agent_family_id, :null => true 
      Integer :agent_corporate_entity_id, :null => true 
      Integer :agent_software_id, :null => true 

      Integer :name_person_id, :null => true 
      Integer :name_family_id, :null => true 
      Integer :name_corporate_entity_id, :null => true 
      Integer :name_software_id, :null => true 

      Integer :related_agents_rlshp_id, :null => true

      Integer :agent_place_id, :null => true
      Integer :agent_occupation_id, :null => true
      Integer :agent_function_id, :null => true
      Integer :agent_topic_id, :null => true

      Integer :agent_gender_id, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:agent_place) do
      primary_key :id

      Integer :place_role_enum_id, :null => false

      Integer :agent_person_id, :null => true
      Integer :agent_family_id, :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id, :null => true

      Integer :publish
      Integer :suppressed

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:subject_agent_place_rlshp) do
      primary_key :id

      Integer :subject_id, :null => true
      Integer :agent_place_id, :null => true

      Integer :aspace_relationship_position

      Integer :suppressed, :default => 0, :null => false

      apply_mtime_columns(false)
    end

    create_table(:agent_occupation) do
      primary_key :id

      Integer :agent_person_id, :null => true
      Integer :agent_family_id, :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id, :null => true

      Integer :publish
      Integer :suppressed

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:subject_agent_occupation_rlshp) do
      primary_key :id

      Integer :subject_id, :null => true
      Integer :agent_occupation_id, :null => true

      Integer :aspace_relationship_position

      Integer :suppressed, :default => 0, :null => false

      apply_mtime_columns(false)
    end

    # for second relationship linking places (also a subject) to occupations. Can't use the table above for both, since we can only use the "agent_occupation_id" FK for one thing at a time
    create_table(:subject_agent_occupation_place_rlshp) do
      primary_key :id

      Integer :subject_id, :null => true
      Integer :agent_occupation_id, :null => true

      Integer :aspace_relationship_position

      Integer :suppressed, :default => 0, :null => false

      apply_mtime_columns(false)
    end

    create_table(:agent_function) do
      primary_key :id

      Integer :agent_person_id, :null => true
      Integer :agent_family_id, :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id, :null => true

      Integer :publish
      Integer :suppressed

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:subject_agent_function_rlshp) do
      primary_key :id

      Integer :subject_id, :null => true
      Integer :agent_function_id, :null => true

      Integer :aspace_relationship_position

      Integer :suppressed, :default => 0, :null => false

      apply_mtime_columns(false)
    end

    # for second relationship linking places (also a subject) to functions. Can't use the table above for both, since we can only use the "agent_function_id" FK for one thing at a time
    create_table(:subject_agent_function_place_rlshp) do
      primary_key :id

      Integer :subject_id, :null => true
      Integer :agent_function_id, :null => true

      Integer :aspace_relationship_position

      Integer :suppressed, :default => 0, :null => false

      apply_mtime_columns(false)
    end

    create_table(:agent_topic) do
      primary_key :id

      Integer :agent_person_id, :null => true
      Integer :agent_family_id, :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id, :null => true

      Integer :publish
      Integer :suppressed

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:subject_agent_topic_rlshp) do
      primary_key :id

      Integer :subject_id, :null => true
      Integer :agent_topic_id, :null => true

      Integer :aspace_relationship_position

      Integer :suppressed, :default => 0, :null => false

      apply_mtime_columns(false)
    end

    # for second relationship linking places (also a subject) to topics. Can't use the table above for both, since we can only use the "agent_topic_id" FK for one thing at a time
    create_table(:subject_agent_topic_place_rlshp) do
      primary_key :id

      Integer :subject_id, :null => true
      Integer :agent_topic_id, :null => true

      Integer :aspace_relationship_position

      Integer :suppressed, :default => 0, :null => false

      apply_mtime_columns(false)
    end
 
    create_table(:agent_gender) do
      primary_key :id

      Integer :gender_enum_id, :null => false

      Integer :agent_person_id, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_table(:agent_identifier) do
      primary_key :id

      Integer :identifier_type_enum_id, :null => true

      String :entity_identifier, :null => false
      
      Integer :agent_person_id, :null => true
      Integer :agent_family_id, :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

  end
end