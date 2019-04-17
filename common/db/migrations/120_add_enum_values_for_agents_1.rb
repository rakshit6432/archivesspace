require_relative 'utils'

Sequel.migration do

  up do
    $stderr.puts "Adding enumerations and values"

    create_enum("maintenence_status", ["new", "upgraded", "revised_corrected", "derived", "deleted", "cancelled_obsolete", "deleted_split", "deleted_replaced"])

		create_enum("publication_status", ["in_process", "approved"])

		create_enum("romanization", ["int_std", "nat_std", "nl_assoc_std", "nl_bib_agency_std", "local_standard", "unknown_standard", "conv_rom_cat_agency", "not_applicable"])

		create_enum("government_agency_type", ["ngo", "sac", "multilocal", "fed", "int_gov", "local", "multistate", "undetermined", "provincial", "unknown", "other", "natc"])

		create_enum("reference_evaluation", ["tr_consistent", "tr_inconsistent", "not_applicable", "natc"])

		create_enum("name_type", ["differentiated", "undifferentiated", "not_applicable", "natc"])

		create_enum("level_of_detail", ["fully_established", "memorandum", "provisional", "preliminary", "not_applicable", "natc"])

		create_enum("modified_record", ["not_modified", "shortened", "missing_characters", "natc"])

		create_enum("cataloging_source", ["nat_bib_agency", "ccp", "other", "unknown", "natc"])

		create_enum("source", ["naf", "snac", "local"], nil, true)

		create_enum("identifier_type", ["loc", "lac", "local"], nil, true)

		create_enum("agency_code_type", ["oclc", "local"], nil, true)

		create_enum("maintenence_event_type", ["created", "cancelled", "deleted", "derived", "revised", "updated"])

		create_enum("maintenence_agent_type", ["human", "machine"], "human")

		create_enum("convention", ["aacr", "ccr", "da", "rda", "rad", "isaar"])

  end
end
