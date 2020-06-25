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
      names(json, xml)
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
    if json['agent_record_identifiers'] && json['agent_record_identifiers'].any?
      primary = json['agent_record_identifiers'].select{|ari| ari['primary_identifier'] == true}

      xml.controlfield(:tag => "001") {
        xml.text primary.first['record_identifier']
      }
    end

    if json['agent_record_controls'] && json['agent_record_controls'].any?
      arc = json['agent_record_controls'].first

      xml.controlfield(:tag => "003") {
        xml.text arc['maintenance_agency']
      }
    end
  end

  def names(json, xml)
    primary = json['names'].select {|n| n['authorized'] == true}.first
    not_primary = json['names'].select {|n| n['authorized'] == false }

    if primary
      xml.datafield(:tag => "100") {
        xml.subfield(:code => "a") {
          xml.text primary['primary_name'] + "," + primary['rest_of_name']
        }

        xml.subfield(:code => "b") {
          xml.text primary['number']
        }

        xml.subfield(:code => "c") {
          xml.text primary['title']
        }

        xml.subfield(:code => "d") {
          xml.text primary['dates']
        }

        xml.subfield(:code => "g") {
          xml.text primary['qualifier']
        }

        xml.subfield(:code => "q") {
          xml.text primary['fuller_form']
        }
      }
    end

  end
end

