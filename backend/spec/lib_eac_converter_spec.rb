require 'spec_helper'
require 'converter_spec_helper'

require_relative '../app/converters/eac_converter'

describe 'EAC converter' do

  let(:my_converter) {
    EACConverter
  }

  let(:person_agent_1) {
    File.expand_path("../app/exporters/examples/eac/feynman-richard-phillips-1918-1988-cr.xml",
                     File.dirname(__FILE__))
  }

  let(:person_agent_2) {
    File.expand_path("../app/exporters/examples/eac/MMeT-C_2012_RCR00751.xml",
                     File.dirname(__FILE__))
  }

  let(:person_agent_3) {
    File.expand_path("../app/exporters/examples/eac/xmleac.xml",
                     File.dirname(__FILE__))
  }


  describe "people agents" do
    it "imports primary_name" do
      record = convert(person_agent_1).first

      expect(record).not_to be_nil
      expect(record['names'][0]['primary_name']).to eq("Feynman, Richard Phillips, 1918-1988.")
    end

    it "imports bioghist notes" do
      record = convert(person_agent_2).first
      note = record["notes"].first["subnotes"].first


      expect(record).not_to be_nil
      expect(note).not_to be_nil

      expect(note["content"]).to match(/Richard H. Lufkin was a shoe machine engineer/)
    end

    it "imports recordId as primary agent_record_identifier" do
      record = convert(person_agent_2).first

      ari = record["agent_record_identifiers"].first


      expect(ari).not_to be_nil

      expect(ari["record_identifier"]).to eq("RCR00751")
      expect(ari["primary_identifier"]).to eq(true)
    end

    it "imports otherRecordId as not primary agent_record_identifier" do
      record = convert(person_agent_3).first

      ars = record["agent_record_identifiers"]

      expect(ars.length).to eq(8)
      expect(ars[1]["record_identifier"]).to eq("11850391X")
      expect(ars[1]["primary_identifier"]).to eq(false)
      expect(ars[1]["identifier_type_enum"]).to eq("PPN")

      expect(ars[2]["record_identifier"]).to eq("http://kalliope-verbund.info/gnd/11850391X")
      expect(ars[2]["primary_identifier"]).to eq(false)
      expect(ars[2]["identifier_type_enum"]).to eq("uriKPE")
    end

    it "imports agent_record_control tags" do
      record = convert(person_agent_3).first

      arc = record["agent_record_controls"].first

      expect(arc["maintenance_status_enum"]).to eq("new")
      expect(arc["agency_name"]).to eq("Deutsche Nationalbibliothek")
      expect(arc["maintenance_agency"]).to eq("DE-101")
      expect(arc["maintenance_agency_note"]).to eq("Agency Note")
      expect(arc["publication_status_enum"]).to eq("approved")
      expect(arc["language"]).to eq("ger")
      expect(arc["script"]).to eq("Latn")
      expect(arc["language_note"]).to eq("Language Note")
    end

    it "imports agent_conventions_declaration tags" do
      record = convert(person_agent_3).first

      acd = record["agent_conventions_declarations"].first

      expect(acd["name_rule"]).to eq("rda")
      expect(acd["citation"]).to eq("The Citation")
      expect(acd["file_uri"]).to eq("http://www.google.com")
      expect(acd["file_version_xlink_actuate_attribute"]).to eq("onRequest")
      expect(acd["file_version_xlink_show_attribute"]).to eq("new")
      expect(acd["xlink_title_attribute"]).to eq("xlink title")
      expect(acd["xlink_role_attribute"]).to eq("xlink role")
      expect(acd["descriptive_note"]).to eq("Convention Note")
      expect(acd["last_verified_date"]).to eq("2000-07-01")
    end

    it "imports agent_maintenance_history tags" do
      record = convert(person_agent_3).first

      mh = record["agent_maintenance_histories"].first

      expect(record["agent_maintenance_histories"].length).to eq(2)

      expect(mh["maintenance_event_type_enum"]).to eq("created")
      expect(mh["maintenance_agent_type_enum"]).to eq("human")
      expect(mh["agent"]).to eq("W4")
      expect(mh["event_date"]).to eq("1988-07-01")
      expect(mh["descriptive_note"]).to eq("Event note 1")
    end

    it "imports agent_source tags" do
      record = convert(person_agent_3).first

      s = record["agent_sources"].first

      expect(s["source_entry"]).to eq("Pressearchiv des Herder-Instituts Marburg")
      expect(s["file_uri"]).to eq("http://www.googlew.com")
      expect(s["file_version_xlink_actuate_attribute"]).to eq("onRequest")
      expect(s["file_version_xlink_show_attribute"]).to eq("new")
      expect(s["xlink_title_attribute"]).to eq("xlink title")
      expect(s["xlink_role_attribute"]).to eq("xlink role")
      expect(s["descriptive_note"]).to eq("Source Note")
      expect(s["last_verified_date"]).to eq("2001-07-01")
    end

    it "imports agent_identifier tags" do
      record = convert(person_agent_3).first

      id = record["agent_identifiers"].first

      expect(id["entity_identifier"]).to eq("auto gen number")
      expect(id["identifier_type_enum"]).to eq("PPX")
    end

    it "imports other parts of name" do
      record = convert(person_agent_3).first

      expect(record['names'][0]['title']).to eq("Dr.")
      expect(record['names'][0]['prefix']).to eq("Mrs.")
      expect(record['names'][0]['primary_name']).to eq("Arendt")
      expect(record['names'][0]['rest_of_name']).to eq("Hannah")
      expect(record['names'][0]['suffix']).to eq("IV")
      expect(record['names'][0]['number']).to eq("4")
      expect(record['names'][0]['fuller_form']).to eq("Fuller Form")
      expect(record['names'][0]['dates']).to eq("1906-1975")
      expect(record['names'][0]['qualifier']).to eq("qualifier")

    end
  end
end
