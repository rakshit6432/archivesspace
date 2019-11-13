require_relative 'utils'

Sequel.migration do

  up do
    $stderr.puts "Adding enumerations and values for new related agents"

  	create_enum("agent_relationship_identity_relator", ["is_identified_with"])
  	create_enum("agent_relationship_hierarchical_relator", ["is_hierarchical_with"])
  	create_enum("agent_relationship_temporal_relator", ["is_temporal_with"])
  	create_enum("agent_relationship_family_relator", ["is_related_with"])

  end
end
