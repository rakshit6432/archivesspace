require_relative 'utils'

Sequel.migration do

  up do
    alter_table(:agent_contact) do
    	drop_column(:note)
    end

    alter_table(:note) do
      add_column(:agent_contact_id, Integer, :null => true)
    end
  end
end
 