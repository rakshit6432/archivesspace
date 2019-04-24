{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "parent" => "abstract_agent",
    "type" => "object",

    "properties" => {
      "primary_identifier" => {"type" => "boolean", "ifmissing" => "error"},
      "record_identifier" => {"type" => "string", "maxLength" => 65000, "ifmissing" => "error"},
      "source_enum" => {
        "dynamic_enum" => "source_enum", 
        "ifmissing" => "error"
      },
      "identifier_type_enum" => {
        "dynamic_enum" => "identifier_type_enum", 
        "default" => ""
      }
    }
  }
}
