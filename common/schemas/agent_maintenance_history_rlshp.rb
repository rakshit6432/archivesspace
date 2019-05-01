{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",
    "properties" => {
      "agent_person_id"           => {"type" => "integer", "required" => false},
      "agent_family_id"           => {"type" => "integer", "required" => false},
      "agent_corporate_entity_id" => {"type" => "integer", "required" => false},
      "agent_software_id"         => {"type" => "integer", "required" => false},
      "agent_maintenance_history_id"    => {"type" => "integer", "required" => true}
      }
  }
}