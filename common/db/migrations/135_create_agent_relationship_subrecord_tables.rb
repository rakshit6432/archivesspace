require_relative 'utils'

Sequel.migration do

  up do
  	# Not sure yet what needs to happen in the database to have a relationship nested in a relationship	(between related_agent_rlshps and subjects), so this is blank for now.
    #alter_table(:subject_rlshp) do
      #add_column(:related_agents_rlshp_id, Integer)
    #end
  end

  down do
  end
end
    