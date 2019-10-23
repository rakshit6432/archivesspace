require_relative 'utils'

Sequel.migration do

  up do
    $stderr.puts "Creating used_language table"

    create_table(:used_language) do
      primary_key :id

      DynamicEnum :language_id, :null => true
      DynamicEnum :script_id, :null => true

      Integer :agent_person_id, :null => true
      Integer :agent_family_id, :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    alter_table(:note) do
      add_column(:used_language_id, Integer, :null => true)
    end
  end
end