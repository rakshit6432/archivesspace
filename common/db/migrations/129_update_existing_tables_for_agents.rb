require_relative 'utils'

Sequel.migration do
  $stderr.puts "Creating new agents tables"
  up do
    alter_table(:name_family) do
      add_column(:family_type, String)
      add_column(:location, String)
    end

    alter_table(:name_corporate_entity) do
      add_column(:location, String)
      add_column(:jurisdiction, Integer, :default => 0)
      add_column(:conference_meeting, Integer, :default => 0)
    end

    alter_table(:note) do
      add_column(:agent_topic_id, Integer, :null => true)
      add_column(:agent_place_id, Integer, :null => true)
      add_column(:agent_occupation_id, Integer, :null => true)
      add_column(:agent_function_id, Integer, :null => true)
    end

    alter_table(:agent_contact) do
    	drop_column(:note)
    end

    alter_table(:note) do
      add_column(:agent_contact_id, Integer, :null => true)
    end
    
    alter_table(:lang_material) do
      add_column(:agent_record_control_id, Integer, :null => true)
      add_column(:agent_person_id, Integer, :null => true)
      add_column(:agent_family_id, Integer, :null => true)
      add_column(:agent_corporate_entity_id, Integer, :null => true)
      add_column(:agent_software_id, Integer, :null => true)
    end
  end
end