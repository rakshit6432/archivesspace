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
                          :last_verified_date => Time.now,
                          :agent_person_id => rand(10000))

    as.save
    expect(as.valid?).to eq(true)
  end

  it "requires an agent_source to point to an agent record" do
    as = AgentSources.new(:file_version_xlink_actuate_attribute => "other",
                          :file_version_xlink_show_attribute => "other",
                          :source_entry => "source_entry",
                          :descriptive_note => "descriptive_note",
                          :file_uri => "file_uri",
                          :xlink_title_attribute => "xlink_title_attribute",
                          :xlink_role_attribute => "xlink_role_attribute",
                          :last_verified_date => Time.now)


    expect(as.valid?).to eq(false)
  end

  it "is invalid if an agent_sources points to more than one agent record" do
   as = AgentSources.new(:file_version_xlink_actuate_attribute => "other",
                          :file_version_xlink_show_attribute => "other",
                          :source_entry => "source_entry",
                          :descriptive_note => "descriptive_note",
                          :file_uri => "file_uri",
                          :xlink_title_attribute => "xlink_title_attribute",
                          :xlink_role_attribute => "xlink_role_attribute",
                          :last_verified_date => Time.now,
                          :agent_person_id => rand(10000),
                          :agent_family_id => rand(10000))

    expect(as.valid?).to eq(false)
  end


end
