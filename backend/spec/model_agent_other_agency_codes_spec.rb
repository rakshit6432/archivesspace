require_relative 'spec_helper'

describe 'AgentOtherAgencyCodes model' do
  it "allows agent_other_agency_codes records to be created" do
    aoac = AgentOtherAgencyCodes.new(:agency_code_type_enum => "oclc",
                                     :maintenance_agency => "maintenance_agency")

    aoac.save
    expect(aoac.valid?).to eq(true)
  end

  it "allows agent_other_agency_codes records to be created from json" do
    pending "failing with NoMethodError"
  	json = build(:agent_other_agency_codes)
    aoac = AgentOtherAgencyCodes.create_from_json(json)
  end
end
