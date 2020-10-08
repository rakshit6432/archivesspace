{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",
    "uri" => "agent_record_identifiers",

    "properties" => {
      "uri"          => {"type" => "string", "required" => false},
      "primary_identifier" => {"type" => "boolean", "ifmissing" => "error"},
      "record_identifier" => {
        "type" => "string", 
        "maxLength" => 65000, 
        "ifmissing" => "error"
      },
      "source_enum" => {
        "type" => "string",
        "dynamic_enum" => "source_enum", 
        "ifmissing" => "error"
      },
      "identifier_type_enum" => {
        "type" => "string",
        "dynamic_enum" => "identifier_type_enum",
        "required" => false
      },
    }
  }
}
