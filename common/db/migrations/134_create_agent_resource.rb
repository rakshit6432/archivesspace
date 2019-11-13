require_relative 'utils'

Sequel.migration do

  up do
    $stderr.puts "Creating agent_resource table"

    create_table(:agent_resource) do
      primary_key :id

      Integer :linked_agent_role_id, :null => false

      String :linked_resource, :null => false
      String :linked_resource_description, :null => true
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

    create_table(:subject_agent_resource_place_rlshp) do
      primary_key :id

      Integer :subject_id, :null => true
      Integer :agent_resource_id, :null => true

      Integer :aspace_relationship_position

      Integer :suppressed, :default => 0, :null => false

      apply_mtime_columns(false)
    end

    alter_table(:structured_date_label) do
      add_column(:agent_resource_id, Integer, :null => true)
    end
  end
end