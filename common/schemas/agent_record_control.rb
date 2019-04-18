{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "parent" => "abstract_agent",
    "type" => "object",

    "properties" => {
      "maintenance_status" => {
        "dynamic_enum" => "maintenance_status",
        "default" => "",
        "ifmissing" => "error"
      },
      "publication_status" => {
        "dynamic_enum" => "publication_status",
        "default" => ""
      },
      "romanization" => {
        "dynamic_enum" => "romanization",
        "default" => ""
      },
      "government_agency_type" => {
        "dynamic_enum" => "government_agency_type",
        "default" => ""
      },
      "reference_evaluation" => {
        "dynamic_enum" => "reference_evaluation",
        "default" => ""
      },
      "name_type" => {
        "dynamic_enum" => "name_type",
        "default" => ""
      },
      "level_of_detail" => {
        "dynamic_enum" => "level_of_detail",
        "default" => ""
      },
      "modified_record" => {
        "dynamic_enum" => "modified_record",
        "default" => ""
      },
      "cataloging_source" => {
        "dynamic_enum" => "cataloging_source",
        "default" => ""
      },
      "maintenance_agency" => {"type" => "string", "maxLength" => 65000},
      "agency_name" => {"type" => "string", "maxLength" => 65000},
      "maintenance_agency_note" => {"type" => "string", "maxLength" => 65000},
      "language" => {"type" => "string", "maxLength" => 65000, "ifmissing" => "error"},  
      "script" => {"type" => "string", "maxLength" => 65000},  
      "language_note" => {"type" => "string", "maxLength" => 65000}
    }
  }
}
