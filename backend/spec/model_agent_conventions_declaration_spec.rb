require_relative 'spec_helper'

describe 'AgentConventionsDeclaration model' do
  it "allows agent_conventions_declaration records to be created" do
    acd = AgentConventionsDeclaration.new(
      :convention_enum => "aacr",
      :file_version_xlink_actuate_attribute => "other",
      :file_version_xlink_show_attribute => "other",
      :citation => "citation",
      :descriptive_note => "descriptive_note",
      :file_uri => "file_uri",
      :xlink_title_attribute => "xlink_title_attribute",
      :xlink_role_attribute => "xlink_role_attribute",
      :last_verified_date => Time.now)

    acd.save
    expect(acd.valid?).to eq(true)
  end

  it "allows agent_conventions_declaration records to be created from json" do
    pending "failing with NoMethodError"
  	json = build(:agent_conventions_declaration)
    acd = AgentConventionsDeclaration.create_from_json(json)
  end
end
