  module EACBaseMap

  # These fields are common to all agent types and imported the same way
  EAC_BASE_MAP_SUBFIELDS = {
    "//eac-cpf//control/recordId" => {
      :obj => :agent_record_identifier,
      :rel => :agent_record_identifiers,
      :map => {
        "self::recordId" => Proc.new {|id, node|
          val = node.inner_text
          id[:record_identifier] = val
          id[:primary_identifier] = true
        }
      },
      :defaults => {
        :primary_identifier => true,
        :source_enum => "local" 
      }
    },
    "//eac-cpf//control/otherRecordId" => {
      :obj => :agent_record_identifier,
      :rel => :agent_record_identifiers,
      :map => {
         "self::otherRecordId" => Proc.new {|id, node|
          val = node.inner_text
          id[:record_identifier] = val
          id[:primary_identifier] = false
          id[:identifier_type_enum] = node.attr("localType")
        },
      },
      :defaults => {
        :primary_identifier => false,
        :source_enum => "local" 
      }
    },
    "//eac-cpf//control" => {
      :obj => :agent_record_control,
      :rel => :agent_record_controls,
      :map => {
        "descendant::maintenanceStatus" => Proc.new {|arc, node|
          val = node.inner_text
          arc[:maintenance_status_enum] = val
        },
        "descendant::maintenanceAgency/agencyCode" => Proc.new {|arc, node|
          val = node.inner_text
          arc[:maintenance_agency] = val
        },
        "descendant::maintenanceAgency/agencyName" => Proc.new {|arc, node|
          val = node.inner_text
          arc[:agency_name] = val
        },
        "descendant::maintenanceAgency/descriptiveNote" => Proc.new {|arc, node|
          val = node.inner_text
          arc[:maintenance_agency_note] = val
        },
        "descendant::publicationStatus" => Proc.new {|arc, node|
          val = node.inner_text
          arc[:publication_status_enum] = val
        },
        "descendant::languageDeclaration/language" => Proc.new {|arc, node|
          arc[:language] = node.attr("languageCode")
          arc[:script] = node.attr("scriptCode")
        },
        "descendant::languageDeclaration/descriptiveNote" => Proc.new {|arc, node|
          val = node.inner_text
          arc[:language_note] = val
        }
      },
      :defaults => {
        :maintenance_status_enum => "new"
      }
    },
    "//eac-cpf/control/conventionDeclaration" => {
      :obj => :agent_conventions_declaration,
      :rel => :agent_conventions_declarations,
      :map => {
        "descendant::abbreviation" => Proc.new {|dec, node|
          val = node.inner_text.downcase
          dec[:name_rule] =  val
        },
        "descendant::citation" => Proc.new {|dec, node|
          val = node.inner_text
          dec[:citation] = (val.nil? || val.length == 0) ? "citation" : val
          dec[:file_uri] = node.attr("href")
          dec[:file_version_xlink_actuate_attribute] = node.attr("actuate")
          dec[:file_version_xlink_show_attribute] = node.attr("show")
          dec[:xlink_title_attribute] = node.attr("title")
          dec[:xlink_role_attribute] = node.attr("role")
          dec[:last_verified_date] = node.attr("lastDateTimeVerified")
        },
        "descendant::descriptiveNote" => Proc.new {|dec, node|
          val = node.inner_text
          dec[:descriptive_note] = val
        },
      },
      :defaults => {
        :citation => "citation",
        :name_rule => "local"
      }
    },
    "//eac-cpf/control/maintenanceHistory/maintenanceEvent" => {
      :obj => :agent_maintenance_history,
      :rel => :agent_maintenance_histories,
      :map => {
        "descendant::eventType" => Proc.new {|me, node|
          val = node.inner_text.downcase
          me[:maintenance_event_type_enum] =  val
        },
        "descendant::agentType" => Proc.new {|me, node|
          val = node.inner_text
          me[:maintenance_agent_type_enum] =  val
        },
        "descendant::agent" => Proc.new {|me, node|
          val = node.inner_text
          me[:agent] =  val
        },
        "descendant::eventDateTime" => Proc.new {|me, node|
          val = node.attr("standardDateTime")
          val2 = node.inner_text

          me[:event_date] =  val
          me[:event_date] = val2 if val.nil?
        },
        "descendant::eventDescription" => Proc.new {|me, node|
          val = node.inner_text
          me[:descriptive_note] =  val
        },
      },
      :defaults => {
      }
    },
    "//eac-cpf/control/sources/source" => {
      :obj => :agent_sources,
      :rel => :agent_sources,
      :map => {
        "self::source" => Proc.new {|s, node|
          s[:file_uri] = node.attr("href")
          s[:file_version_xlink_actuate_attribute] = node.attr("actuate")
          s[:file_version_xlink_show_attribute] = node.attr("show")
          s[:xlink_title_attribute] = node.attr("title")
          s[:xlink_role_attribute] = node.attr("role")
          s[:last_verified_date] = node.attr("lastDateTimeVerified")
        },
        "descendant::sourceEntry" => Proc.new {|s, node|
          val = node.inner_text
          s[:source_entry] = val
        },
        "descendant::descriptiveNote" => Proc.new {|s, node|
          val = node.inner_text
          s[:descriptive_note] = val
        },
      },
      :defaults => {
      }
    },
    "//eac-cpf/cpfDescription/identity/entityId" => {
      :obj => :agent_identifier,
      :rel => :agent_identifiers,
      :map => {
        "self::entityId" => Proc.new {|id, node|
          val = node.inner_text
          id[:entity_identifier] = val
          id[:identifier_type_enum] = node.attr("localType")
        }
      },
      :defaults => {
      }
    },
    "//eac-cpf/cpfDescription/description/existDates/date" => {
      :obj => :structured_date_label,
      :rel => :dates_of_existence,
      :map => {
        "self::date" => Proc.new {|date, node|
          exp = node.inner_text
          role = "begin"
          label = "existence"
          type = "single"

          if node.attr("standardDate")
            std = node.attr("standardDate")

            if node.attr("notBefore")
              std_type = node.attr("notBefore")
            elsif node.attr("notAfter")
              std_type = node.attr("notAfter")
            else
              std_type = nil
            end
          else
            std = nil
            std_type = nil
          end

          sds = ASpaceImport::JSONModel(:structured_date_single).new({
            :date_role_enum => role,
            :date_expression => exp,
            :date_standardized => std,
            :date_standardized_type_enum => std_type
          })

          date[:date_label] = label
          date[:date_type_enum] = type
          date[:structured_date_single] = sds
        }
      },
      :defaults => {
      }
    },
    "//eac-cpf/cpfDescription/description/existDates/dateRange" => {
      :obj => :structured_date_label,
      :rel => :dates_of_existence,
      :map => {
        "self::dateRange" => Proc.new {|date, node|
          label = "existence"
          type = "range"

          begin_node = node.search("//fromDate")
          end_node = node.search("//toDate")

          #STDERR.puts node.inspect
          #STDERR.puts begin_node.inspect

          begin_exp = begin_node.inner_text
          end_exp = end_node.inner_text

          begin_std = begin_node.attr("standardDate") ? begin_node.attr("standardDate").value : nil
          end_std = end_node.attr("standardDate") ? end_node.attr("standardDate").value : nil

          if begin_std
            if begin_node.attr("notBefore")
              begin_std_type = begin_node.attr("notBefore").value
            elsif begin_node.attr("notAfter")
              begin_std_type = begin_node.attr("notAfter").value
            else
              begin_std_type = nil
            end
          else
            begin_std_type = nil
          end

          if end_std
            if end_node.attr("notBefore")
              end_std_type = end_node.attr("notBefore").value
            elsif end_node.attr("notAfter")
              end_std_type = end_node.attr("notAfter").value
            else
              end_std_type = nil
            end
          else
            end_std_type = nil
          end

          #STDERR.puts "++++++++++++++++++++++++++++++"
          #STDERR.puts begin_exp.inspect
          #STDERR.puts begin_std.inspect
          #STDERR.puts begin_std_type.inspect

          sdr = ASpaceImport::JSONModel(:structured_date_range).new({
            :begin_date_expression => begin_exp,
            :begin_date_standardized => begin_std,
            :begin_date_standardized_type_enum => begin_std_type,
            :end_date_expression => end_exp,
            :end_date_standardized => end_std,
            :end_date_standardized_type_enum => end_std_type
          })

          date[:date_label] = label
          date[:date_type_enum] = type
          date[:structured_date_range] = sdr
        }
      },
      :defaults => {
      }
    },
    #"//places/place" => {
    #  :obj => :agent_place,
    #  :rel => :agent_places,
    #  :map => {
    #    "descendant::placeRole" => Proc.new {|apl, node|
    #      val = node.inner_text
    #      apl[:place_role_enum] = val
    #    },
    #    "descendant::placeEntry" => Proc.new {|apl, node|
    #      term = node.inner_text
    #      source = node.attr("vocabularySource")

    #      STDERR.puts "++++++++++++++++++++++++++++++"

    #     # make :subject, {
    #     #   :terms => {'term' => term, 'term_type' => 'geographic', 'vocabulary' => '/vocabularies/1'},
    #     #   :vocabulary => '/vocabularies/1',
    #     #   :source => source
    #     # } do |subject|
    #     #     STDERR.puts subject.inspect
    #     #     #set apl, :subjects, {'ref' => subject.uri}
    #     #     apl[:subjects].push({'ref' => subject.uri})
    #     #   end
    #     s = ASpaceImport::JSONModel(:subject).new({
    #        :terms => {'term' => term, 'term_type' => 'geographic', 'vocabulary' => '/vocabularies/1'},
    #        :vocabulary => '/vocabularies/1',
    #        :source => source
    #     })

    #     STDERR.puts s.inspect
    #     apl[:subjects].push(s.uri)
    #    },
    #  },
    #  :defaults => {
    #  }
    #},
    "//eac-cpf//biogHist" => {
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

  def EAC_BASE_MAP
    {
      # AGENT PERSON
      "//eac-cpf//cpfDescription[child::identity/child::entityType='person']" => {
        :obj => :agent_person,
        :map => {
          # NAMES (PERSON)
          "descendant::nameEntry" => {
            :obj => :name_person,
            :rel => :names,
            :map => {
              "self::nameEntry[@lang]" => Proc.new {|name, node|
                name[:language] = node.attr("lang")
              },
              "self::nameEntry[@scriptCode]" => Proc.new {|name, node|
                name[:script] = node.attr("scriptCode")
              },
              "descendant::part[@localType='prefix']" => Proc.new {|name, node|
                val = node.inner_text
                name[:prefix] = val
              },
              "descendant::part[@localType='suffix']" => Proc.new {|name, node|
                val = node.inner_text
                name[:suffix] = val
              },
              "descendant::part[@localType='title']" => Proc.new {|name, node|
                val = node.inner_text
                name[:title] = val
              },
              "descendant::part[@localType='surname']" => Proc.new {|name, node|
                val = node.inner_text
                name[:primary_name] = val
              },
              "descendant::part[@localType='forename']" => Proc.new {|name, node|
                val = node.inner_text
                name[:rest_of_name] = val
              },
              "descendant::part[@localType='numeration']" => Proc.new {|name, node|
                val = node.inner_text
                name[:number] = val
              },
              "descendant::part[@localType='fuller_form']" => Proc.new {|name, node|
                val = node.inner_text
                name[:fuller_form] = val
              },
              "descendant::part[@localType='dates']" => Proc.new {|name, node|
                val = node.inner_text
                name[:dates] = val
              },
              "descendant::part[@localType='qualifier']" => Proc.new {|name, node|
                val = node.inner_text
                name[:qualifier] = val
              },
              "descendant::authorizedForm" => Proc.new {|name, node|
                val = node.inner_text
                name[:source] = val
                name[:authorized] = true
              },
              "descendant::alternativeForm" => Proc.new {|name, node|
                val = node.inner_text
                name[:source] = val
                name[:authorized] = false
              },
              "descendant::part[not(@localType)]" => Proc.new {|name, node|
                val = node.inner_text
                name[:primary_name] = val
                name[:dates] = val.scan(/[0-9]{4}-[0-9]{4}/).flatten[0]
              }, # if localType attr is not defined, assume primary_name
              "descendant::part[not(@localType='prefix') and not(@localType='prefix') and not(@localType='suffix') and not(@localType='title')  and not(@localType='surname')  and not(@localType='forename') and not(@localType='numeration') and not(@localType='fuller_form') and not(@localType='dates') and not(@localType='qualifier')]" => Proc.new {|name, node|
                val = node.inner_text
                name[:primary_name] = val
                name[:dates] = val.scan(/[0-9]{4}-[0-9]{4}/).flatten[0]
              }, # if localType attr is something else
            },
            :defaults => {
              :source => 'local',
              :rules => 'local',
              :primary_name => 'primary name',
              :name_order => 'direct',
            }
          }
        }.merge(EAC_BASE_MAP_SUBFIELDS)
      },
      # AGENT CORPORATE ENTITY
      "//eac-cpf//cpfDescription[child::identity/child::entityType='corporateBody']" => {
        :obj => :agent_corporate_entity,
        :map => {
          # NAMES (PERSON)
          "descendant::nameEntry" => {
            :obj => :name_corporate_entity,
            :rel => :names,
            :map => {
              "self::nameEntry[@lang]" => Proc.new {|name, node|
                name[:language] = node.attr("lang")
              },
              "self::nameEntry[@scriptCode]" => Proc.new {|name, node|
                name[:script] = node.attr("scriptCode")
              },
              "descendant::part[@localType='primary_name']" => Proc.new {|name, node|
                val = node.inner_text
                name[:primary_name] = val
              },
              "descendant::part[@localType='subordinate_name_1']" => Proc.new {|name, node|
                val = node.inner_text
                name[:subordinate_name_1] = val
              },
              "descendant::part[@localType='subordinate_name_2']" => Proc.new {|name, node|
                val = node.inner_text
                name[:subordinate_name_2] = val
              },
              "descendant::part[@localType='numeration']" => Proc.new {|name, node|
                val = node.inner_text
                name[:number] = val
              },
              "descendant::part[@localType='location']" => Proc.new {|name, node|
                val = node.inner_text
                name[:location] = val
              },
              "descendant::part[@localType='dates']" => Proc.new {|name, node|
                val = node.inner_text
                name[:dates] = val
              },
              "descendant::part[@localType='qualifier']" => Proc.new {|name, node|
                val = node.inner_text
                name[:qualifier] = val
              },
              "descendant::authorizedForm" => Proc.new {|name, node|
                val = node.inner_text
                name[:source] = val
                name[:authorized] = true
              },
              "descendant::alternativeForm" => Proc.new {|name, node|
                val = node.inner_text
                name[:source] = val
                name[:authorized] = false
              },
              "descendant::part[not(@localType)]" => Proc.new {|name, node|
                val = node.inner_text
                name[:primary_name] = val
                name[:dates] = val.scan(/[0-9]{4}-[0-9]{4}/).flatten[0]
              }, # if localType attr is not defined, assume primary_name
              "descendant::part[not(@localType='primary_name') and not(@localType='subordinate_name_1') and not(@localType='subordinate_name_2') and not(@localType='numeration') and not(@localType='location') and not(@localType='dates') and not(@localType='qualifier')]" => Proc.new {|name, node|
                val = node.inner_text
                name[:primary_name] = val
                name[:dates] = val.scan(/[0-9]{4}-[0-9]{4}/).flatten[0]
              }, # if localType attr is something else
             "descendant::useDates/date" => {
               :obj => :structured_date_label,
               :rel => :use_dates,
               :map => {
                 "self::date" => Proc.new {|date, node|
                   exp = node.inner_text
                   role = "begin"
                   label = "usage"
                   type = "single"

                   if node.attr("standardDate")
                     std = node.attr("standardDate")

                     if node.attr("notBefore")
                       std_type = node.attr("notBefore")
                     elsif node.attr("notAfter")
                       std_type = node.attr("notAfter")
                     else
                       std_type = nil
                     end
                   else
                     std = nil
                     std_type = nil
                   end

                   sds = ASpaceImport::JSONModel(:structured_date_single).new({
                     :date_role_enum => role,
                     :date_expression => exp,
                     :date_standardized => std,
                     :date_standardized_type_enum => std_type
                   })

                   date[:date_label] = label
                   date[:date_type_enum] = type
                   date[:structured_date_single] = sds
                 },
               }  
             },
             
            }, # end of map
           :defaults => {
              :source => 'local',
              :rules => 'local',
              :primary_name => 'primary name',
              :name_order => 'direct',
           }
          }
        }.merge(EAC_BASE_MAP_SUBFIELDS),
      },
      # AGENT FAMILY
      "//eac-cpf//cpfDescription[child::identity/child::entityType='family']" => {
        :obj => :agent_family,
        :map => {
          # NAMES (FAMILY)
          "descendant::nameEntry" => {
            :obj => :name_family,
            :rel => :names,
            :map => {
              "self::nameEntry[@lang]" => Proc.new {|name, node|
                name[:language] = node.attr("lang")
              },
              "self::nameEntry[@scriptCode]" => Proc.new {|name, node|
                name[:script] = node.attr("scriptCode")
              },
              "descendant::part[@localType='prefix']" => Proc.new {|name, node|
                val = node.inner_text
                name[:prefix] = val
              },
              "descendant::part[@localType='surname']" => Proc.new {|name, node|
                val = node.inner_text
                name[:family_name] = val
              },
              "descendant::part[@localType='family_type']" => Proc.new {|name, node|
                val = node.inner_text
                name[:family_type] = val
              },
              "descendant::part[@localType='location']" => Proc.new {|name, node|
                val = node.inner_text
                name[:location] = val
              },
              "descendant::part[@localType='dates']" => Proc.new {|name, node|
                val = node.inner_text
                name[:dates] = val
              },
              "descendant::part[@localType='qualifier']" => Proc.new {|name, node|
                val = node.inner_text
                name[:qualifier] = val
              },
              "descendant::authorizedForm" => Proc.new {|name, node|
                val = node.inner_text
                name[:source] = val
                name[:authorized] = true
              },
              "descendant::alternativeForm" => Proc.new {|name, node|
                val = node.inner_text
                name[:source] = val
                name[:authorized] = false
              },
              "descendant::part[not(@localType)]" => Proc.new {|name, node|
                val = node.inner_text
                name[:family_name] = val
                name[:dates] = val.scan(/[0-9]{4}-[0-9]{4}/).flatten[0]
              }, # if localType attr is not defined, assume primary_name
              "descendant::part[not(@localType='prefix') and not(@localType='surname') and not(@localType='family_type') and not(@localType='location') and not(@localType='dates') and not(@localType='qualifier')]" => Proc.new {|name, node|
                val = node.inner_text
                name[:family_name] = val
                name[:dates] = val.scan(/[0-9]{4}-[0-9]{4}/).flatten[0]
              }, # if localType attr is something else, assume primary_name
            },
            :defaults => {
              :source => 'local',
              :rules => 'local',
              :primary_name => 'primary name',
              :name_order => 'direct',
            }
          }
        }.merge(EAC_BASE_MAP_SUBFIELDS)
      }
    }
  end
end
