require_relative 'utils'

Sequel.migration do

  up do
    create_table(:agent_date) do
      primary_key :id

      Integer :date_label_id, :null => false # existing enum date_label
      Integer :date_type_enum_id, :null => false
      Integer :date_role_enum_id, :null => true

      String :begin_date_expression, :null => true
      DateTime :begin_date_standardized, :null => true
      Integer :begin_date_standardized_type_enum_id, :null => true

      String :end_date_expression, :null => true
      DateTime :end_date_standardized, :null => true
      Integer :end_date_standardized_type_enum_id, :null => true

      Integer :date_certainty_id, :null => true # existing enum date_certainty
      Integer :date_era_id, :null => true # existing enum date_era
      Integer :date_calendar_id, :null => true # existing enum date_calendar

      apply_mtime_columns
      Integer :lock_version, :default => 0, :null => false
    end

    create_enum("date_type_enum", ["single", "range"])
    create_enum("date_role_enum", ["begin", "end"])
    create_enum("begin_date_standardized_type_enum", ["standard", "not_before", "not_after"])
    create_enum("end_date_standardized_type_enum", ["standard", "not_before", "not_after"])
  end

end