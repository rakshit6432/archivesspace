{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "parent" => "abstract_agent",
    "type" => "object",

    "properties" => {
      "maintenance_status_enum" => {
        "dynamic_enum" => "maintenance_status_enum",
        "default" => "",
        "ifmissing" => "error"
      },
      "publication_status_enum" => {
        "dynamic_enum" => "publication_status_enum",
        "default" => ""
      },
      "romanization_enum" => {
        "dynamic_enum" => "romanization_enum",
        "default" => ""
      },
      "government_agency_type_enum" => {
        "dynamic_enum" => "government_agency_type_enum",
        "default" => ""
      },
      "reference_evaluation_enum" => {
        "dynamic_enum" => "reference_evaluation_enum",
        "default" => ""
      },
      "name_type_enum" => {
        "dynamic_enum" => "name_type_enum",
        "default" => ""
      },
      "level_of_detail_enum" => {
        "dynamic_enum" => "level_of_detail_enum",
        "default" => ""
      },
      "modified_record_enum" => {
        "dynamic_enum" => "modified_record_enum",
        "default" => ""
      },
      "cataloging_source_enum" => {
        "dynamic_enum" => "cataloging_source_enum",
        "default" => ""
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
