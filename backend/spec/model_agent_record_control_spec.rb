require_relative 'spec_helper'

describe 'AgentRecordControl model' do

  it "allows agent_record_control records to be created" do

  	# todo: fix spelling for maint
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
                                 :language_note => "language_note")


    arc.save
    expect(arc.valid?).to eq(true)
  end

  it "allows agent_record_control records to be created from json" do
		# this is failing with a NoMethodError undefined method `schema' for AgentRecordControl:Class  	
    pending "failing with NoMethodError"
  	json = build(:agent_record_control)
    arc = AgentRecordControl.create_from_json(json)
  end
end
