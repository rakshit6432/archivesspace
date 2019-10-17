require_relative 'utils'

Sequel.migration do

  up do
    $stderr.puts "Adding tables for parallel name forms for agents"

    create_table(:parallel_name_person) do
      primary_key :id

      Integer :lock_version, :default => 0, :null => false
      Integer :json_schema_version, :null => false

      Integer :name_person_id, :null => false

      String :primary_name, :null => false
      DynamicEnum :name_order_id, :null => false

      Integer :language_id
      Integer :script_id
      Integer :romanization_enum_id

      HalfLongString :title, :null => true
      TextField :prefix, :null => true
      TextField :rest_of_name, :null => true
      TextField :suffix, :null => true
      TextField :fuller_form, :null => true
      String :number, :null => true

      apply_parallel_name_columns

      apply_mtime_columns
    end

    create_table(:parallel_name_family) do
      primary_key :id

      Integer :lock_version, :default => 0, :null => false
      Integer :json_schema_version, :null => false

      Integer :name_family_id, :null => false

      String :family_type
      String :location

      Integer :language_id
      Integer :script_id
      Integer :romanization_enum_id

      TextField :family_name, :null => false

      TextField :prefix, :null => true

      apply_parallel_name_columns

      apply_mtime_columns
    end

    create_table(:parallel_name_corporate_entity) do
      primary_key :id

      Integer :lock_version, :default => 0, :null => false
      Integer :json_schema_version, :null => false

      Integer :name_corporate_entity_id, :null => false

      String :location
      Integer :jurisdiction, :default => 0
      Integer :conference_meeting, :default => 0

      Integer :language_id
      Integer :script_id
      Integer :romanization_enum_id

      TextField :primary_name, :null => false

      TextField :subordinate_name_1, :null => true
      TextField :subordinate_name_2, :null => true
      String :number, :null => true

      apply_parallel_name_columns

      apply_mtime_columns
    end

    create_table(:parallel_name_software) do
      primary_key :id

      Integer :lock_version, :default => 0, :null => false
      Integer :json_schema_version, :null => false

      Integer :name_software_id, :null => false

      Integer :language_id
      Integer :script_id
      Integer :romanization_enum_id

      TextField :software_name, :null => false

      TextField :version, :null => true
      TextField :manufacturer, :null => true

      apply_parallel_name_columns

      apply_mtime_columns
    end
  end
end