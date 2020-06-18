require 'spec_helper'
require 'converter_spec_helper'

require_relative '../app/converters/marcxml_auth_agent_converter'

describe 'MARCXML Auth Agent converter' do

  def my_converter
    MarcXMLAuthAgentConverter
  end

  let(:person_agent_1) {
    File.expand_path("../app/exporters/examples/marc/authority_john_davis.xml",
                     File.dirname(__FILE__))
  }


  describe "agent person" do
    before(:all) do
    end

    it "converts agent name from marc auth" do
      record = convert(person_agent_1).select {|r| r['jsonmodel_type'] == "agent_person"}.first

      expect(record['names'][0]['primary_name']).to eq("Davis")
    end
  end

  describe "common subrecords" do
    it "imports agent_record_control" do
      record = convert(person_agent_1).select {|r| r['jsonmodel_type'] == "agent_person"}.first

      expect(record['agent_record_controls'][0]['maintenance_status_enum']).to eq("revised_corrected")
      expect(record['agent_record_controls'][0]['maintenance_agency']).to eq("DLC")
      expect(record['agent_record_controls'][0]['romanization_enum']).to eq("not_applicable")
      expect(record['agent_record_controls'][0]['language']).to eq("fre")
      expect(record['agent_record_controls'][0]['government_agency_type_enum']).to eq("unknown")
      expect(record['agent_record_controls'][0]['reference_evaluation_enum']).to eq("tr_consistent")
      expect(record['agent_record_controls'][0]['name_type_enum']).to eq("differentiated")
      expect(record['agent_record_controls'][0]['level_of_detail_enum']).to eq("fully_established")
      expect(record['agent_record_controls'][0]['modified_record_enum']).to eq("not_modified")
      expect(record['agent_record_controls'][0]['cataloging_source_enum']).to eq("nat_bib_agency")
    end

    it "imports agent_record_identifier" do
      record = convert(person_agent_1).select {|r| r['jsonmodel_type'] == "agent_person"}.first

      expect(record['agent_record_identifiers'][0]['record_identifier']).to eq("n  88218900")
      expect(record['agent_record_identifiers'][0]['identifier_type_enum']).to eq("local")
      expect(record['agent_record_identifiers'][0]['source_enum']).to eq("DLC")
      expect(record['agent_record_identifiers'][0]['primary_identifier']).to eq(true)
    end

    it "imports agent_maintenance_histories" do
      record = convert(person_agent_1).select {|r| r['jsonmodel_type'] == "agent_person"}.first


      expect(record['agent_maintenance_histories'][0]['event_date']).to eq("19890119")
      expect(record['agent_maintenance_histories'][0]['maintenance_event_type_enum']).to eq("created")
      expect(record['agent_maintenance_histories'][0]['maintenance_agent_type_enum']).to eq("machine")
      expect(record['agent_maintenance_histories'][0]['agent']).to eq("DLC")
    end
  end
end
