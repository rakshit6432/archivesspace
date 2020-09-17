{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",
    "uri" => "agent_genders",

    "properties" => {
      "uri"          => {"type" => "string", "required" => false},
      "gender_enum" => {"type" => "string", "dynamic_enum" => "gender_enum"},

      "dates" => {
        "type" => "array",
        "items" => {"type" => "JSONModel(:structured_date_label) object"}
      },
      "notes" => {
        "type" => "array",
        "items" => {"type" => [{"type" => "JSONModel(:note_text) object"},
                               {"type" => "JSONModel(:note_citation) object"}]},
      },
    },
  },
}