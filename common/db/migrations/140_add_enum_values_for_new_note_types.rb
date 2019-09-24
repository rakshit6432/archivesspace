require_relative 'utils'

Sequel.migration do

  up do
    $stderr.puts "Adding adding enum values for new note types"

    add_values_to_enum("note_multipart_type", ["general_context", "mandate", "legal_status", "structure_or_genealogy"])
  end
end
