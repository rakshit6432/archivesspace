require_relative 'utils'

Sequel.migration do

  up do
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
 