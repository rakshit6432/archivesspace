require_relative 'utils'

Sequel.migration do

  up do
    create_table(:structured_date_agent_rlshp) do
      primary_key :id

      Integer :agent_person_id, :null => false
      Integer :agent_family_id, :null => false
      Integer :agent_corporate_entity_id, :null => false
      Integer :agent_software_id, :null => false
      Integer :structured_date_label_id, :null => false

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end
  end
end