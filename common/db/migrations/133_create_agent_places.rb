require_relative 'utils'

Sequel.migration do

  up do
  	create_enum("place_role_enum", ["assoc_country", "residence", "other_assoc", "place_of_birth", "place_of_death"])

    create_table(:agent_place) do
      primary_key :id

      Integer :place_role_enum_id, :null => false

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

    alter_table(:structured_date_label) do
    	add_column(:agent_place_id, Integer, :null => true)
    end

    create_table(:subject_agent_place_rlshp) do
      primary_key :id

      Integer :subject_id, :null => true
      Integer :agent_place_id, :null => true

      Integer :aspace_relationship_position

      Integer :suppressed, :default => 0, :null => false

      apply_mtime_columns(false)
    end
  end
end
 