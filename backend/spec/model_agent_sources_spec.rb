require_relative 'spec_helper'

describe 'AgentSources model' do
  it "allows agent_sources records to be created" do
    as = AgentSources.new(:file_version_xlink_actuate_attribute => "other",
                          :file_version_xlink_show_attribute => "other",
                          :source_entry => "source_entry",
                          :descriptive_note => "descriptive_note",
                          :file_uri => "file_uri",
                          :xlink_title_attribute => "xlink_title_attribute",
                          :xlink_role_attribute => "xlink_role_attribute",
                          :last_verified_date => Time.now)

    as.save
    expect(as.valid?).to eq(true)
  end

  it "allows agent_sources records to be created from json" do
    pending "failing with NoMethodError"
  	json = build(:agent_sources)
    as = AgentSources.create_from_json(json)
  end
end
