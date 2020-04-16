module EACBaseMap

  def EAC_BASE_MAP
    {
      # RECORD CONTROL METADATA

      # AGENT PERSON
      # //cpfDescription[child::identity/child::entityType='person']
      "//eac-cpf" => {
        :obj => :agent_person,
        :map => {
          # NAMES (PERSON)
          "descendant::nameEntry" => {
            :obj => :name_person,
            :rel => :names,
            :map => {
              "descendant::part" => Proc.new {|name, node|
                val = node.inner_text
                name[:primary_name] = val
                name[:dates] = val.scan(/[0-9]{4}-[0-9]{4}/).flatten[0]
              },
            },
            :defaults => {
              :source => 'local',
              :rules => 'local',
              :primary_name => 'primary name',
              :name_order => 'direct',
            }
          },
          "descendant::control" => {
            :obj => :agent_record_identifier,
            :rel => :agent_record_identifiers,
            :map => {
              "descendant::recordId" => Proc.new {|id, node|
                val = node.inner_text
                id[:record_identifier] = val
              },
            },
              :defaults => {
                :primary_identifier => false,
                :source_enum => "naf" 
              }
            },
          "descendant::conventionDeclaration" => {
            :obj => :agent_conventions_declaration,
            :rel => :agent_conventions_declarations,
            :map => {
              "descendant::abbreviation" => Proc.new {|dec, node|
                val = node.inner_text.downcase
                dec[:name_rule] =  val
              },
              "descendant::citation" => Proc.new {|dec, node|
                val = node.inner_text
                dec[:citation] = val
              },
              "descendant::descriptiveNote" => Proc.new {|dec, node|
                val = node.inner_text
                dec[:descriptive_note] = val
              },
            },
            :defaults => {
              :citation => "citation",
              :name_rule => "local", 
              :file_version_xlink_actuate_attribute => "none",
              :file_version_xlink_show_attribute => "none"
            }
          },
          "descendant::biogHist" => {
            :obj => :note_bioghist,
            :rel => :notes,
            :map => {
              "self::biogHist" => Proc.new {|note, node|
                note['subnotes'] << {
                  'jsonmodel_type' => 'note_text',
                  'content' => node.inner_text
                }
              }
            },
            :defaults => {
              :label => 'default label'
            }
          }
        }
      }

    }
  end
end
