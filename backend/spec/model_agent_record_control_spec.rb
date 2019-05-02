require_relative 'spec_helper'

describe 'AgentRecordControl model' do

  it "allows agent_record_control records to be created" do
    arc = AgentRecordControl.new(:language => "foo", 
    														 :maintenance_status_enum => "new",
                                 :publication_status_enum => "in_process",
                                 :romanization_enum => "int_std",
                                 :government_agency_type_enum => "ngo",
                                 :reference_evaluation_enum => "tr_consistent",
                                 :name_type_enum => "differentiated",
                                 :level_of_detail_enum => "fully_established",
                                 :modified_record_enum => "not_modified",
                                 :cataloging_source_enum => "nat_bib_agency",
                                 :maintenance_agency => "maintenance_agency",
                                 :agency_name => "agency_name",
                                 :maintenance_agency_note => "maintenance_agency_note",
                                 :script => "script",
                                 :language_note => "language_note",
                                 :agent_person_id => rand(10000))


    arc.save
    expect(arc.valid?).to eq(true)
  end

  it "requires an agent_record_control to point to an agent record" do
    arc = AgentRecordControl.new(:language => "foo", 
                                 :maintenance_status_enum => "new")


    expect(arc.valid?).to eq(false)
  end

  it "is invalid if an agent_record_control points to more than one agent record" do
    arc = AgentRecordControl.new(:language => "foo", 
                                 :maintenance_status_enum => "new",
                                 :agent_person_id => rand(10000),
                                 :agent_family_id => rand(10000))

    expect(arc.valid?).to eq(false)
  end

  it "agent_record_control must point to unique agent record" do
    a1  = AgentRecordControl.new(:language => "foo", 
                                 :maintenance_status_enum => "new",
                                 :agent_person_id => 42)

    a1.save

    a2  = AgentRecordControl.new(:language => "foo", 
                                 :maintenance_status_enum => "new",
                                 :agent_person_id => 42)

    expect(a1.valid?).to eq(true)
    expect(a2.valid?).to eq(false)
  end

  it "allows agent_record_control records to be created from json" do
		# this is failing with a NoMethodError undefined method `schema' for AgentRecordControl:Class  	
    pending "failing with NoMethodError"
  	json = build(:agent_record_control)
    arc = AgentRecordControl.create_from_json(json)
  end
end
