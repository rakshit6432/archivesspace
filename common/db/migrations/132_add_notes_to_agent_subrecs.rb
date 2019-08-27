require_relative 'utils'

Sequel.migration do

  up do
    alter_table(:agent_topic) do
    	drop_column(:text_note)
    end

    alter_table(:agent_place) do
      drop_column(:text_note)
    end

    alter_table(:agent_occupation) do
      drop_column(:text_note)
    end

    alter_table(:agent_function) do
      drop_column(:text_note)
    end

    alter_table(:note) do
      add_column(:agent_topic_id, Integer, :null => true)
      add_column(:agent_place_id, Integer, :null => true)
      add_column(:agent_occupation_id, Integer, :null => true)
      add_column(:agent_function_id, Integer, :null => true)
    end
  end
end
 