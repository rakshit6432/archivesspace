{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",

    "properties" => {
      "date_label" => {"type" => "string", "dynamic_enum" => "date_label", "ifmissing" => "error"},
      "date_type_enum" => {"type" => "string", "dynamic_enum" => "date_type_enum", "ifmissing" => "error"},
      "structured_dates" => {
        "required" => true,
        "type" => "array",
        "items" => {"type" => "JSONModel(:structured_date) object"}
      },
    },
  },
}
