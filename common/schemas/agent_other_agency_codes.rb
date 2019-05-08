{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "parent" => "abstract_agent",
    "type" => "object",

    "properties" => {
      "agency_code_type_enum" => {
          "type" => "string",
          "dynamic_enum" => "agency_code_type_enum",
          "ifmissing" => "error"
      },
      "maintenance_agency" => {
          "type" => "string", 
          "maxLength" => 65000, 
          "ifmissing" => "error"
      },
      "agent_person_id"           => {"type" => "integer", "required" => false},
      "agent_family_id"           => {"type" => "integer", "required" => false},
      "agent_corporate_entity_id" => {"type" => "integer", "required" => false},
      "agent_software_id"         => {"type" => "integer", "required" => false}
    }
  }
}
