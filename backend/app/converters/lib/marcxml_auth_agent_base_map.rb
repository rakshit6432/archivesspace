module MarcXMLAuthAgentBaseMap

  def BASE_RECORD_MAP
    {
      # AGENT PERSON
      "//datafield[@tag='100' and @ind1='1']" => {
        :obj => :agent_person,
        :map => agent_person_base      
      },
      # AGENT CORPORATE ENTITY
      "//datafield[@tag='110']" => {
        :obj => :agent_corporate_entity,
        :map => agent_corporate_entity_base
      },
      # AGENT FAMILY
      "//datafield[@tag='100' and @ind1='3']" => {
        :obj => :agent_family,
        :map => agent_family_base
      }
    }
  end

  def agent_person_base
    {
      "//record/leader" => agent_record_control_map,
      "self::datafield" => agent_person_name_with_parallel_map(:name_person, :names)
    }
  end

  def agent_corporate_entity_base
    {
      "//leader" => agent_record_control_map,
      "self::datafield" => agent_corporate_entity_name_map(:name_corporate_entity, :names)
    }
  end

  def agent_family_base
    {
      "//leader" => agent_record_control_map,
      "self::datafield" => agent_family_name_map(:name_family, :names)
    }
  end

  def agent_person_name_with_parallel_map(obj, rel)
    {
      :obj => obj,
      :rel => rel,
      :map => agent_person_name_components_map.merge({
        "//datafield[@tag='400' and @ind1='1']" => agent_person_name_map(:parallel_name_person, :parallel_names)
      }),
      :defaults => {
        :source => 'local',
        :rules => 'local',
        :primary_name => 'primary name',
        :name_order => 'direct',
      }
    }
  end

  def agent_person_name_map(obj, rel)
    {
      :obj => obj,
      :rel => rel,
      :map => agent_person_name_components_map,
      :defaults => {
        :source => 'local',
        :rules => 'local',
        :primary_name => 'primary name',
        :name_order => 'direct',
      }
    }
  end

  def agent_corporate_entity_name_map(obj, rel)
    {
      :obj => obj,
      :rel => rel,
      :map => agent_corporate_entity_name_components_map,
      :defaults => {
        :source => 'local',
        :rules => 'local',
        :primary_name => 'primary name',
        :name_order => 'direct',
      }
    }
  end

  def agent_family_name_map(obj, rel)
    {
      :obj => obj,
      :rel => rel,
      :map => agent_family_name_components_map,
      :defaults => {
        :source => 'local',
        :rules => 'local',
        :primary_name => 'primary name',
        :name_order => 'direct',
      }
    }
  end

  def agent_person_name_components_map
    {
       "descendant::subfield[@code='a']" => Proc.new {|name, node|
          val = node.inner_text

          if val =~ /,/
            nom_parts = val.split(",")
          else
            nom_parts = val.split(" ")
          end

          name[:primary_name] = nom_parts[0]
          name[:rest_of_name] = nom_parts[1]
       },
       "descendant::subfield[@code='d']" => Proc.new {|name, node|
          val = node.inner_text
          name[:dates] = val
       },
    }
  end

  def agent_corporate_entity_name_components_map
    {
      "descendant::subfield[@code='a']" => Proc.new {|name, node|
          val = node.inner_text

          name[:primary_name] = val
       },
    }
  end

  def agent_family_name_components_map
    {
      "descendant::subfield[@code='a']" => Proc.new {|name, node|
          val = node.inner_text

          name[:family_name] = val
       },
    }
  end

  def agent_record_control_map
  {
    :obj => :agent_record_control,
    :rel => :agent_record_controls,
    :map => {
      "self::leader" => Proc.new{|arc, node|
        leader_text = node.inner_text

        case leader_text[5]
        when 'n'
          status = "new"
        when 'a'
          status = "upgraded"
        when 'c'
          status = "revised_corrected"
        when 'd'
          status = "deleted"
        when 'o'
          status = "cancelled_obsolete"
        when 's'
          status = "deleted_split"
        when 'x'
          status = "deleted_replaced"
        end

        arc['maintenance_status_enum'] = status
      },
      "//record/controlfield[@tag='003']" => Proc.new{|arc, node|
        org = node.inner_text
        arc['maintenance_agency'] = org
      },

      # looks something like:
      # <marcxml:controlfield tag="008">890119nnfacannaab           |a aaa      </marcxml:controlfield>
      "//record/controlfield[@tag='008']" => Proc.new{|arc, node|
        tag8_content = node.inner_text

        case tag8_content[7]
        when 'a'
          romanization = "int_std"
        when 'b'
          romanization = "nat_std"
        when 'c'
          romanization = "nl_assoc_std"
        when 'd'
          romanization = "nl_bib_agency_std"
        when 'e'
          romanization = "local_std"
        when 'f'
          romanization = "unknown_std"
        when 'g'
          romanization = "conv_rom_cat_agency"
        when 'n'
          romanization = "not_applicable"
        when '|'
          romanization = ""
        end

        case tag8_content[8]
        when 'b'
          lang = "eng"
        when 'e'
          lang = "eng"
        when 'f'
          lang = "fre"
        end

        case tag8_content[28]
        when '#'
          gov_agency = "ngo"
        when 'a'
          gov_agency = "sac"
        when 'c'
          gov_agency = "multilocal"
        when 'f'
          gov_agency = "fed"
        when 'I'
          gov_agency = "int_gov"
        when 'l'
          gov_agency = "local"
        when 'm'
          gov_agency = "multistate"
        when 'o'
          gov_agency = "undetermined"
        when 's'
          gov_agency = "provincial"
        when 'u'
          gov_agency = "unknown"
        when 'z'
          gov_agency = "other"
        when '|'
          gov_agency = "unknown"
        end

        case tag8_content[29]
        when 'a'
          ref_eval = 'tr_consistent'
        when 'b'
          ref_eval = 'tr_inconsistent'
        when 'n'
          ref_eval = 'not_applicable'
        when '|'
          ref_eval = 'natc'
        end

        case tag8_content[32]
        when 'a'
          name_type = 'differentiated'
        when 'b'
          name_type = 'undifferentiated'
        when 'n'
          name_type = 'not_applicable'
        when '|'
          name_type = 'natc'
        end

        case tag8_content[33]
        when 'a'
          lod = 'fully_established'
        when 'b'
          lod = 'memorandum'
        when 'c'
          lod = 'provisional'
        when 'd'
          lod = 'preliminary'
        when 'n'
          lod = 'not_applicable'
        when '|'
          lod = 'natc'
        end

        case tag8_content[38]
        when '#'
          mod_record = 'not_modified'
        when 's'
          mod_record = 'shortened'
        when 'x'
          mod_record = 'missing_characters'
        when '|'
          mod_record = 'natc'
        end

        case tag8_content[39]
        when '#'
          catalog_source = 'nat_bib_agency'
        when 'c'
          catalog_source = 'ccp'
        when 'd'
          catalog_source = 'other'
        when 'u'
          catalog_source = 'unknown'
        when '|'
          catalog_source = 'natc'
        end


        arc['romanization_enum'] = romanization
        arc['language'] = lang
        arc['government_agency_type_enum'] = gov_agency
        arc['reference_evaluation_enum'] = ref_eval
        arc['name_type_enum'] = name_type
        arc['level_of_detail_enum'] = lod
        arc['modified_record_enum'] = mod_record
        arc['cataloging_source_enum'] = catalog_source
      },
      "//record/datafield[@tag='040']/subfield[@code='a']" => Proc.new{|arc, node| 
        val = node.inner_text

        arc['maintenance_agency'] = val
      },
     "//record/datafield[@tag='040']/subfield[@code='b']" => Proc.new{|arc, node| 
        val = node.inner_text

        arc['language'] = val
      },
     "//record/datafield[@tag='040']/subfield[@code='d']" => Proc.new{|arc, node| 
        val = node.inner_text

        arc['maintenance_agency'] = val
      }
    }
  }
  end
end
