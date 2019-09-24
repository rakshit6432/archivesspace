require_relative 'utils'

Sequel.migration do

  up do
    create_table(:agent_topic) do
      primary_key :id

      String :text_note, :null => true

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
 

    alter_table(:structured_date_label) do
    	add_column(:agent_topic_id, Integer, :null => true)
    end
  end
end
 