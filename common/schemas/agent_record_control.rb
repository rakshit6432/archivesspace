{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "parent" => "abstract_agent",
    "type" => "object",

    "properties" => {
      "maintenance_status_enum" => {
        "type" => "string",
        "dynamic_enum" => "maintenance_status_enum",
        "ifmissing" => "error",
        "required" => true
      },
      "publication_status_enum" => {
        "type" => "string",
        "dynamic_enum" => "publication_status_enum",
        "required" => false
      },
      "romanization_enum" => {
        "type" => "string",
        "dynamic_enum" => "romanization_enum",
        "required" => false
      },
      "government_agency_type_enum" => {
        "type" => "string",
        "dynamic_enum" => "government_agency_type_enum",
        "required" => false
      },
      "reference_evaluation_enum" => {
        "type" => "string",
        "dynamic_enum" => "reference_evaluation_enum",
        "required" => false
      },
      "name_type_enum" => {
        "type" => "string",
        "dynamic_enum" => "name_type_enum",
        "required" => false
      },
      "level_of_detail_enum" => {
        "type" => "string",
        "dynamic_enum" => "level_of_detail_enum",
        "required" => false
      },
      "modified_record_enum" => {
        "type" => "string",
        "dynamic_enum" => "modified_record_enum",
        "required" => false
      },
      "cataloging_source_enum" => {
        "type" => "string",
        "dynamic_enum" => "cataloging_source_enum",
        "required" => false
      },
      "maintenance_agency" => {"type" => "string", "maxLength" => 65000},
      "agency_name" => {"type" => "string", "maxLength" => 65000},
      "maintenance_agency_note" => {"type" => "string", "maxLength" => 65000},
      "language" => {"type" => "string", "maxLength" => 65000, "ifmissing" => "error"},  
      "script" => {"type" => "string", "maxLength" => 65000},  
      "language_note" => {"type" => "string", "maxLength" => 65000},
      "agent_person_id"           => {"type" => "integer", "required" => false},
      "agent_family_id"           => {"type" => "integer", "required" => false},
      "agent_corporate_entity_id" => {"type" => "integer", "required" => false},
      "agent_software_id"         => {"type" => "integer", "required" => false}
    }
  }
}
