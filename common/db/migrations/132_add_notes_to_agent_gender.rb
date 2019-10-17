require_relative 'utils'

Sequel.migration do

  up do
    $stderr.puts "Adding FK for agent_gender to notes table"

    alter_table(:note) do
      add_column(:agent_gender_id, Integer, :null => true)
    end

  end
end