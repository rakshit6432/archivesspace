{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",

    "properties" => {
      "date_role_enum" => {"type" => "string", "dynamic_enum" => "date_role_enum" },

      "date_expression" => {"type" => "string", "maxLength" => 255},
      "date_standardized" => {"type" => "string", "maxLength" => 255},
      "date_standardized_type_enum" => {"type" => "string", "dynamic_enum" => "date_standardized_type_enum", "required" => "false"},
  
      "date_certainty" => {"type" => "string", "dynamic_enum" => "date_certainty", "required" => "false"},
      "date_era" => {"type" => "string", "dynamic_enum" => "date_era", "required" => "false"},
      "date_calendar" => {"type" => "string", "dynamic_enum" => "date_calendar", "required" => "false"}
    },
  },
}
