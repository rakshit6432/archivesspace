require_relative 'utils'

Sequel.migration do

  up do
    alter_table(:subject) do
      add_column(:related_agents_rlshp_id, Integer)
    end

    #create_table(:subject_related_agents_rlshp_place_rlshp) do
    #  primary_key :id

    #  Integer :subject_id, :null => true
    #  Integer :related_agents_rlshp_id, :null => true

    #  Integer :aspace_relationship_position

    #  Integer :suppressed, :default => 0, :null => false

    #  apply_mtime_columns(false)
    # end
  end

  down do
  end
end
    