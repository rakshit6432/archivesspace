require_relative 'utils'

Sequel.migration do

  up do
    # for dates of existence
    create_table(:structured_date_agent_rlshp) do
      primary_key :id

      Integer :agent_person_id, :null => true
      Integer :agent_family_id, :null => true
      Integer :agent_corporate_entity_id, :null => true
      Integer :agent_software_id, :null => true
      Integer :structured_date_label_id, :null => false

      apply_mtime_columns
      Integer :aspace_relationship_position, :null => true
      Integer :suppressed, :default => 0, :null => false
    end

    # for dates of name use
    create_table(:structured_date_name_rlshp) do
      primary_key :id

      Integer :name_person_id, :null => true
      Integer :name_family_id, :null => true
      Integer :name_corporate_entity_id, :null => true
      Integer :name_software_id, :null => true
      Integer :structured_date_label_id, :null => false

      apply_mtime_columns
      Integer :aspace_relationship_position, :null => true
      Integer :suppressed, :default => 0, :null => false
    end

    # for agent relationship dates
    create_table(:structured_date_related_agents_rlshp) do
      primary_key :id

      Integer :related_agents_rlshp_id, :null => false
      Integer :structured_date_label_id, :null => false

      apply_mtime_columns
      Integer :aspace_relationship_position, :null => true
      Integer :suppressed, :default => 0, :null => false
    end
  end
end