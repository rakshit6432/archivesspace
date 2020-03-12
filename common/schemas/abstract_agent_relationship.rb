{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",
    "subtype" => "ref",
    "properties" => {
      "description" => {"type" => "string", "maxLength" => 65000},
      "dates" => {"type" => "JSONModel(:structured_date_label) object"}
      # Changes to support agent relationships having places and dates commented out for now until we figure out what the plumbing needs to be in the models.
      #"dates" => {"type" => "JSONModel(:structured_date_label) object"},
      #"places" => {
        #"type" => "array",
        #"items" => {
          #"type" => "object",
          #"subtype" => "ref",
          #"properties" => {
            #"ref" => {
              #"type" => "JSONModel(:subject) uri",
              #"ifmissing" => "error"
            #},
            #"_resolved" => {
              #"type" => "object",
              #"readonly" => "true"
            #}
          #}
        #}
      #}
    }
  }
}
