{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "parent" => "abstract_agent",
    "type" => "object",

    "properties" => {
      "convention" => {
        "dynamic_enum" => "convention",
        "ifmissing" => "error"
      },
      "citation" => {"type" => "string", "maxLength" => 65000, "ifmissing" => "error"},
      "descriptive_note" => {"type" => "string", "maxLength" => 65000},
      "file_uri" => {"type" => "string", "maxLength" => 65000},
      "xlink_actuate_attribute" => {"type" => "string", "dynamic_enum" => "file_version_xlink_actuate_attribute"},
      "xlink_show_attribute" => {"type" => "string", "dynamic_enum" => "file_version_xlink_show_attribute"},
      "xlink_title_attribute" => {"type" => "string", "maxLength" => 65000},
      "xlink_role_attribute" => {"type" => "string", "maxLength" => 65000},
      "last_verified_date" => {"type" => "JSONModel(:date) object"}
    }
  }
}
