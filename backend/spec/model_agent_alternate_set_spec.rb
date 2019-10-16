require_relative 'spec_helper'

describe 'AgentAlternateSet model' do

  it "validates the record making sure at least one of set component, file uri or description is set" do
    pending
  end

  it "allows agent_alternate_set records to be created" do
    aas = AgentAlternateSet.new(:file_version_xlink_actuate_attribute => "other",
                                :file_version_xlink_show_attribute => "other",
                                :set_component => "set_component",
                                :descriptive_note => "descriptive_note",
                                :file_uri => "file_uri",
                                :xlink_title_attribute => "xlink_title_attribute",
                                :xlink_role_attribute => "xlink_role_attribute",
                                :last_verified_date => Time.now,
                                :agent_person_id => rand(10000))

    aas.save
    expect(aas.valid?).to eq(true)
  end

  it "requires an agent_alternate_set to point to an agent record" do
    aas = AgentAlternateSet.new(:file_version_xlink_actuate_attribute => "other",
                                :file_version_xlink_show_attribute => "other",
                                :set_component => "set_component",
                                :descriptive_note => "descriptive_note",
                                :file_uri => "file_uri",
                                :xlink_title_attribute => "xlink_title_attribute",
                                :xlink_role_attribute => "xlink_role_attribute",
                                :last_verified_date => Time.now)

    expect(aas.valid?).to eq(false)
  end

  it "is invalid if an agent_alternate_set points to more than one agent record" do

    aas = AgentAlternateSet.new(:file_version_xlink_actuate_attribute => "other",
                                :file_version_xlink_show_attribute => "other",
                                :set_component => "set_component",
                                :descriptive_note => "descriptive_note",
                                :file_uri => "file_uri",
                                :xlink_title_attribute => "xlink_title_attribute",
                                :xlink_role_attribute => "xlink_role_attribute",
                                :last_verified_date => Time.now,
                                :agent_person_id => rand(10000),
                                :agent_family_id => rand(10000))

    expect(aas.valid?).to eq(false)
  end

end
