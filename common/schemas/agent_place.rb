{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",

    "properties" => {
      "place_role_enum" => {"type" => "string", "dynamic_enum" => "place_role_enum"},

      "text_note" => {"type" => "string", "maxLength" => 255},

      "dates" => {
        "type" => "array",
        "items" => {"type" => "JSONModel(:structured_date_label) object"}
      },

      "subjects" => {
        "type" => "array",
        "items" => {
          "type" => "object",
          "subtype" => "ref",
          "properties" => {
            "ref" => {
              "type" => "JSONModel(:subject) uri",
              "ifmissing" => "error"
            },
            "_resolved" => {
              "type" => "object",
              "readonly" => "true"
            }
          }
        }
      },
    },
  },
}