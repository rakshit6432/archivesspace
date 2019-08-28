require_relative 'utils'

Sequel.migration do

  up do
  	create_enum("gender_enum", ["male", "female", "not_known"])

    create_table(:agent_gender) do
      primary_key :id

      Integer :gender_enum_id, :null => false

      Integer :agent_person_id, :null => true

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    alter_table(:structured_date_label) do
    	add_column(:agent_gender_id, Integer, :null => true)
    end
  end
end
 