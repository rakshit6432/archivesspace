class MARCAuthSerializer < ASpaceExport::Serializer
  serializer_for :marc_auth
  
  def serialize(marc, opts = {})

    builder = Nokogiri::XML::Builder.new(:encoding => "UTF-8") do |xml|
      _marc(marc, xml)     
    end
    
    builder.to_xml   
  end
  
  private

  # wrapper around nokogiri that creates a node without empty attrs and nodes
  def create_node(xml, node_name, attrs, text)
    unless text.nil? || text.empty?
      attrs = attrs.reject {|k, v| v.nil? }
      xml.send(node_name, attrs) {
        xml.text text
      }
    end
  end

  def filled_out?(values, mode = :some)
    if mode == :all
      values.inject {|memo, v| memo && (!v.nil? && !v.empty?) }
    else mode == :some
      values.inject {|memo, v| memo || (!v.nil? && !v.empty?) }
    end
  end

  def clean_attrs(attrs)
    attrs.reject {|k, v| v.nil? }
  end
  
  def _marc(obj, xml)  
    json = obj.json

    xml.send("record", {'xmlns:marcxml' => "http://www.loc.gov/MARC21/slim", 
'xmlns:rdf' => "http://www.w3.org/1999/02/22-rdf-syntax-ns#", 
'xmlns:madsrdf' => "http://www.loc.gov/mads/rdf/v1#", 
'xmlns:ri' => "http://id.loc.gov/ontologies/RecordInfo#", 
'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance", 
'xmlns:mets' => "http://www.loc.gov/METS/"}) {
      _leader(json, xml)
      _controlfields(json, xml)
      ids(json, xml)
      names(json, xml)
      record_control(json, xml)
      dates_of_existence(json, xml)
    }
  end

  def _leader(json, xml)
    xml.leader {
      if json['agent_record_controls'] && json['agent_record_controls'].any?
        arc = json['agent_record_controls'].first

        case arc['maintenance_status_enum']
        when "new"
          pos5 = 'n'
        when "upgraded"
          pos5 = 'a'
        when "revised_corrected"
          pos5 = 'c'
        when "deleted"
          pos5 = 'd'
        when "cancelled_obsolete"
          pos5 = 'o'
        when "deleted_split"
          pos5 = 's'
        when "deleted_replaced"
          pos5 = 'x'
        end

        if arc['level_of_detail_enum'] == "fully_established"
          pos17 = 'n'
        else
          pos17 = 'o'
        end

        pos12_16 = "00000"
      else
        pos5 = 'n'
        pos12_16 = "00000"
        pos17 = 'o'
      end

      xml.text "00000#{pos5}z  a22#{pos12_16}#{pos17}  4500"
    }
  end

  def _controlfields(json, xml)
    aid = agent_id(json)

    xml.controlfield(:tag => "001") {
      xml.text aid
    }

    if json['agent_record_controls'] && json['agent_record_controls'].any?
      arc = json['agent_record_controls'].first

      xml.controlfield(:tag => "003") {
        xml.text arc['maintenance_agency']
      }
    end

    if json['agent_maintenance_histories'] && json['agent_maintenance_histories'].any?

      most_recent = json['agent_maintenance_histories'].sort {|a, b| b['event_date'] <=> a['event_date']}.first

      puts most_recent['event_date']

      xml.controlfield(:tag => "005") {
        xml.text most_recent['event_date'].strftime("%Y%m%d%H%M%S.f")
      }
    end

    controlfield_008(json, xml)
  end

  # this field is mostly from agent_record_control record.
  def controlfield_008(json, xml)
    created_maint_events = json['agent_maintenance_histories'].select {|amh| amh['maintenance_event_type_enum'] == 'created'}
    if created_maint_events.any?
      pos0_5 = created_maint_events.first['event_date'].strftime("%y%m%d")
    else
      pos0_5 = "000000"
    end

    if json['agent_record_controls'] && json['agent_record_controls'].any?
      arc = json['agent_record_controls'].first
      case arc['romanization_enum']
      when 'int_std'
        pos_7 = "a"
      when 'nat_std'
        pos_7 = "b"
      when 'nl_assoc_std'
        pos_7 = "c"
      when 'nl_bib_agency_std'
        pos_7 = "d"
      when 'local_standard'
        pos_7 = "e"
      when 'unknown_standard'
        pos_7 = "f"
      when 'conv_rom_cat_agency'
        pos_7 = "g"
      when 'not_applicable'
        pos_7 = "n"
      end

      if arc['language']['eng']
        pos_8 = 'e'
      elsif arc['language']['fre']
        pos_8 = 'f'
      else
        pos_8 = '|'
      end

      case arc['government_agency_type_enum']
      when 'ngo'
        pos_28 = " "
      when 'sac'
        pos_28 = "a"
      when 'multilocal'
        pos_28 = "c"
      when 'fed'
        pos_28 = "f"
      when 'int_gov'
        pos_28 = "I"
      when 'local'
        pos_28 = "l"
      when 'multistate'
        pos_28 = "m"
      when 'undetermined'
        pos_28 = "o"
      when 'provincial'
        pos_28 = "s"
      when 'unknown'
        pos_28 = "u"
      when 'other'
        pos_28 = "z"
      when 'natc'
        pos_28 = "|"
      end

      case arc['reference_evaluation_enum']
      when 'tr_consistent' 
        pos_29 = "a"
      when 'tr_inconsistent' 
        pos_29 = "b"
      when 'not_applicable' 
        pos_29 = "n"
      when 'natc' 
        pos_29 = "|"
      end

      case arc['name_type_enum']
      when 'differentiated' 
        pos_32 = "a"
      when 'undifferentiated' 
        pos_32 = "b"
      when 'not_applicable' 
        pos_32 = "n"
      when 'natc' 
        pos_32 = "|"
      end

      case arc['level_of_detail_enum']
      when "fully_established"
        pos_33 = "a"
      when "memorandum"
        pos_33 = "b"
      when "provisional"
        pos_33 = "c"
      when "preliminary"
        pos_33 = "d"
      when "not_applicable"
        pos_33 = "n"
      when "natc"
        pos_33 = "|"
      end

      case arc['modified_record_enum']
      when "not_modified" 
        pos_38 = " "
      when "shortened"
        pos_38 = "s"
      when "missing_characters"
        pos_38 = "x"
      when "natc"
        pos_38 = "|"
      end

      case arc['cataloging_source_enum']
      when "nat_bib_agency" 
        pos_39 = " "
      when "ccp"
        pos_39 = "c"
      when "other"
        pos_39 = "d"
      when "unknown"
        pos_39 = "u"
      when "natc"
        pos_39 = "|"
      end
    else
      pos_7 = "|"
      pos_8 = "|"
      pos_28 = "|"
      pos_29 = "|"
      pos_32 = "|"
      pos_33 = "|"
      pos_38 = "|"
      pos_39 = "|"
    end

    xml.controlfield(:tag => "008") {
      xml.text "#{pos0_5}n#{pos_7}#{pos_8}aznnnaabn          #{pos_28}#{pos_29} a#{pos_32}#{pos_33}    #{pos_38}#{pos_39}"
    }
  end

  def ids(json, xml)
    if json['agent_record_identifiers'] && json['agent_record_identifiers'].any?
      loc_ids = json['agent_record_identifiers'].select{ |ari| ari['identifier_type_enum'] == "loc" }
      lac_ids = json['agent_record_identifiers'].select{ |ari| ari['identifier_type_enum'] == "lac" }
      local_ids = json['agent_record_identifiers'].select{ |ari| ari['identifier_type_enum'] == "local" }
      other_ids = json['agent_record_identifiers'].select{ |ari| !["loc", "lac", "local"].include?(ari['identifier_type_enum']) }

      if loc_ids.any?
        xml.datafield(:tag => "010", :ind1 => " ", :ind2 => " ") {
          xml.subfield(:code => "a") {
            xml.text loc_ids.first["record_identifier"]
          }
        }
      end

      if lac_ids.any?
        xml.datafield(:tag => "016", :ind1 => " ", :ind2 => " ") {
          xml.subfield(:code => "a") {
            xml.text lac_ids.first["record_identifier"]
          }

          xml.subfield(:code => "2") {
            xml.text lac_ids.first["source_enum"]
          }
        }
      end

      if other_ids.any?
        xml.datafield(:tag => "024", :ind1 => "7", :ind2 => " ") {
          xml.subfield(:code => "a") {
            xml.text other_ids.first["record_identifier"]
          }

          xml.subfield(:code => "2") {
            xml.text other_ids.first["source_enum"]
          }
        }
      end

      if local_ids.any?
        xml.datafield(:tag => "035", :ind1 => " ", :ind2 => " ") {
          xml.subfield(:code => "a") {
            xml.text local_ids.first["record_identifier"]
          }

          xml.subfield(:code => "2") {
            xml.text local_ids.first["source_enum"]
          }
        }
      end
    end
  end

  def record_control(json, xml)
    if (json['agent_record_controls'] && json['agent_record_controls'].any?) 
      arc = json['agent_record_controls'].first
      a_value = arc['maintenance_agency']
      b_value = arc['language']
      # TODO: d_value? but we don't store a modifying agency
    end

    if (json['agent_conventions_declarations'] && json['agent_conventions_declarations'].any?) 
      acd = json['agent_conventions_declarations'].first
      e_value = acd['name_rule']
    end

    if a_value || b_value || e_value
      xml.datafield(:tag => "040") {
        if a_value
          xml.subfield(:code => "a") {
            xml.text a_value
          }
        end

        if b_value
          xml.subfield(:code => "b") {
            xml.text b_value
          }
        end

        if e_value
          xml.subfield(:code => "e") {
            xml.text e_value
          }
        end
      }
    end
  end

  def names(json, xml)
    primary = json['names'].select {|n| n['authorized'] == true}.first
    not_primary = json['names'].select {|n| n['authorized'] == false }

    parallel_names = []
    json['names'].each do |n|
      parallel_names += n['parallel_names']
    end

    if agent_type(json) == :person
      names_person(primary, not_primary, parallel_names, xml)
    elsif agent_type(json) == :family
      names_family(primary, not_primary, parallel_names, xml)
    elsif agent_type(json) == :corp
      names_corporate_entity(primary, not_primary, parallel_names, xml)
    end
  end

  def names_person(primary, not_primary, parallel, xml)
    # the primary name gets the 100 tag
    if primary
      xml.datafield(:tag => "100") {
        person_name_subtags(primary, xml) 
      }
    end

    # all other names and parallel names are put in 400 tags
    not_primary.each do |n|
      xml.datafield(:tag => "400") {
        person_name_subtags(n, xml) 
      }
    end

    parallel.each do |n|
      xml.datafield(:tag => "400") {
        person_name_subtags(n, xml) 
      }
    end
  end

  def person_name_subtags(name, xml)
    xml.subfield(:code => "a") {
      if name['rest_of_name']
        xml.text name['primary_name'] + "," + name['rest_of_name']
      else 
        xml.text name['primary_name']
      end
        
    }

    if name['number']
      xml.subfield(:code => "b") {
        xml.text name['number']
      }
    end

    if name['title']
      xml.subfield(:code => "c") {
        xml.text name['title']
      }
    end

    if name['dates']
      xml.subfield(:code => "d") {
        xml.text name['dates']
      }
    end

    if name['qualifier']
      xml.subfield(:code => "g") {
        xml.text name['qualifier']
      }
    end

    if name['fuller_form']
      xml.subfield(:code => "q") {
        xml.text name['fuller_form']
      }
    end
  end


  def names_family(primary, not_primary, parallel, xml)
    # the primary name gets the 100 tag
    if primary
      xml.datafield(:tag => "100") {
        family_name_subtags(primary, xml) 
      }
    end

    # all other names and parallel names are put in 400 tags
    not_primary.each do |n|
      xml.datafield(:tag => "400") {
        family_name_subtags(n, xml) 
      }
    end

    parallel.each do |n|
      xml.datafield(:tag => "400") {
        family_name_subtags(n, xml) 
      }
    end
  end

  def family_name_subtags(name, xml)
    xml.subfield(:code => "a") {
      xml.text name['family_name']
    }

    if name['qualifier']
      xml.subfield(:code => "b") {
        xml.text name['qualifier']
      }

      xml.subfield(:code => "c") {
        xml.text name['qualifier']
      }

      xml.subfield(:code => "g") {
        xml.text name['qualifier']
      }
    end

    if name['dates']
      xml.subfield(:code => "d") {
        xml.text name['dates']
      }
    end
  end

  def names_corporate_entity(primary, not_primary, parallel, xml)
    if primary
      if primary['conference_meeting'] == true
        xml.datafield(:tag => "111") {
          corporate_name_subtags(primary, xml) 
        }
      else
        xml.datafield(:tag => "100") {
          corporate_name_subtags(primary, xml) 
        }
      end
    end

    # all other names and parallel names are put in 400 tags
    not_primary.each do |n|
      if n['conference_meeting'] == true
        xml.datafield(:tag => "411") {
          corporate_name_subtags(n, xml) 
        }
      else
        xml.datafield(:tag => "410") {
          corporate_name_subtags(n, xml) 
        }
      end
    end

    parallel.each do |n|
      if n['conference_meeting'] == true
        xml.datafield(:tag => "411") {
          corporate_name_subtags(n, xml) 
        }
      else
        xml.datafield(:tag => "410") {
          corporate_name_subtags(n, xml) 
        }
      end
    end
  end

  def corporate_name_subtags(name, xml)
    xml.subfield(:code => "a") {
      xml.text name['primary_name']
    }

    if name['subordinate_name_1']
      xml.subfield(:code => "b") {
        xml.text name['subordinate_name_1']
      }
    end

    if name['subordinate_name_2']
      xml.subfield(:code => "q") {
        xml.text name['subordinate_name_2']
      }
    end

    if name['location']
      xml.subfield(:code => "c") {
        xml.text name['location']
      }
    end

    if name['dates']
      xml.subfield(:code => "d") {
        xml.text name['dates']
      }
    end

    if name['number']
      xml.subfield(:code => "n") {
        xml.text name['number']
      }
    end

    if name['qualifier']
      xml.subfield(:code => "g") {
        xml.text name['qualifier']
      }
    end
  end

  def dates_of_existence(json, xml)
    if (json['dates_of_existence'] && json['dates_of_existence'].any?) 
      json['dates_of_existence'].each do |doe|
        if doe['date_type_enum'] == "single"
          begin_date = doe['structured_date_single']['date_expression']
        elsif doe['date_type_enum'] == "range"
          begin_date = doe['structured_date_range']['begin_date_expression']
          end_date = doe['structured_date_range']['end_date_expression']
        end

        if agent_type(json) == :person
          begin_code = "f"
          end_code = "g"
        elsif agent_type(json) == :family || agent_type(json) == :corp
          begin_code = "s"
          end_code = "t"
        end

        xml.datafield(:tag => "046") {
          xml.subfield(:code => begin_code) {
            xml.text begin_date
          }

          if end_date 
            xml.subfield(:code => end_code) {
              xml.text end_date
            }
          end
        }
      end
    end
  end


  # returns an ID for the agent, depending on what is defined.
  # IDs used are (in order)
  # Record IDs
  # Entity IDs
  # Name Auth ID
  # System URI
  def agent_id(json)
    names_with_auth_id = json['names'].select {|n| !n['authority_id'].nil? && !n['authority_id'].empty? }

    if json['agent_record_identifiers'].any?
      return json['agent_record_identifiers'].first['record_identifier']

    elsif json['agent_identifiers'].any?
      return json['agent_identifiers'].first['agent_identifier']

    elsif names_with_auth_id.any?
      return names_with_auth_id.first['authority_id']

    else
      return "#{AppConfig[:public_proxy_url]}#{json['uri']}"
    end
  end

  def agent_type(json)
    case json['jsonmodel_type']
    when "agent_person"
      return :person
    when "agent_family"
      return :family
    when "agent_corporate_entity"
      return :corp
    end
  end

end

