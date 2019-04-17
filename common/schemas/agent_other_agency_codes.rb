{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "parent" => "abstract_agent",
    "type" => "object",

    "properties" => {
      "maintenance_agency" => {"type" => "string", "maxLength" => 65000, "ifmissing" => "error"},
      "agency_code_type" => 
        {"dynamic_enum" => "agency_code_type", 
         "ifmissing" => "error", 
         "default" => ""},
    },
  },
}
