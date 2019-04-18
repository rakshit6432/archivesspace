{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "parent" => "abstract_agent",
    "type" => "object",

    "properties" => {
      "event_type" => {
        "dynamic_enum" => "maintenence_event_type", 
        "ifmissing" => "error", 
        "default" => ""
      },
      "agency_type" => {
        "dynamic_enum" => "maintenence_agent_type", 
        "ifmissing" => "error", 
        "default" => "Human"
      },
      "event_date" => {"type" => "JSONModel(:date) object", "ifmissing" => "error"},
      "agent" => {"type" => "string", "maxLength" => 65000, "ifmissing" => "error"},
      "descriptive_note" => {"type" => "string", "maxLength" => 65000}
    }
  }
}
