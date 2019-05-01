require_relative 'spec_helper'

describe 'AgentAlternateSet model' do
  it "allows agent_alternate_set records to be created" do
    aas = AgentAlternateSet.new(:file_version_xlink_actuate_attribute => "other",
                                :file_version_xlink_show_attribute => "other",
                                :set_component => "set_component",
                                :descriptive_note => "descriptive_note",
                                :file_uri => "file_uri",
                                :xlink_title_attribute => "xlink_title_attribute",
                                :xlink_role_attribute => "xlink_role_attribute",
                                :last_verified_date => Time.now)

    aas.save
    expect(aas.valid?).to eq(true)
  end

  it "allows agent_alternate_set records to be created from json" do
    pending "failing with NoMethodError"
  	json = build(:agent_alternate_set)
    aas = AgentAlternateSet.create_from_json(json)
  end
end
