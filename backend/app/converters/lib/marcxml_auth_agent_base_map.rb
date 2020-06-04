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
      "self::datafield" => agent_person_name_with_parallel_map(:name_person, :names)
    }
  end

  def agent_corporate_entity_base
    {
      "self::datafield" => agent_corporate_entity_name_map(:name_corporate_entity, :names)
    }
  end

  def agent_family_base
    {
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
end
