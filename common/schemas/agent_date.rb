{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",

    "properties" => {
      "date_label" => {"type" => "string", "dynamic_enum" => "date_label", "ifmissing" => "error"},
      "date_type_enum" => {"type" => "string", "dynamic_enum" => "date_type_enum", "ifmissing" => "error"},
      "date_role_enum" => {"type" => "string", "dynamic_enum" => "date_role_enum" },

      "begin_date_expression" => {"type" => "string", "maxLength" => 255},
      "begin_date_standardized" => {"type" => "date-time", "maxLength" => 255},
      "begin_date_standardized_type_enum" => {"type" => "string", "dynamic_enum" => "begin_date_standardized_type_enum", "required" => "false"},

      "end_date_expression" => {"type" => "string", "maxLength" => 255},
      "end_date_standardized" => {"type" => "date-time", "maxLength" => 255},
      "end_date_standardized_type_enum" => {"type" => "string", "dynamic_enum" => "end_date_standardized_type_enum", "required" => "false"},

      "date_certainty" => {"type" => "string", "dynamic_enum" => "date_certainty", "required" => "false"},
      "date_era" => {"type" => "string", "dynamic_enum" => "date_era", "required" => "false"},
      "date_calendar" => {"type" => "string", "dynamic_enum" => "date_calendar", "required" => "false"}
    },
  },
}
