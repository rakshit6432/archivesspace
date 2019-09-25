require_relative 'utils'

Sequel.migration do

  up do
    alter_table(:agent_record_control) do
    	drop_column(:language)
      drop_column(:script)
      drop_column(:language_note)
    end

    alter_table(:lang_material) do
      add_column(:agent_record_control_id, Integer, :null => true)
    end
  end
end
 