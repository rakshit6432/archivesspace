require_relative 'spec_helper'

describe 'AgentRecordIdentifier model' do
  it "allows agent_record_identifier records to be created" do
    ari = AgentRecordIdentifier.new(
      :identifier_type_enum => "loc",
      :source_enum => "naf",
      :primary_identifier => rand(10000),
      :record_identifier => "record_identifer")

    ari.save
    expect(ari.valid?).to eq(true)
  end

  it "allows agent_record_identifier records to be created from json" do
    pending "failing with NoMethodError"
  	json = build(:agent_record_identifier)
    ari = AgentRecordIdentifier.create_from_json(json)
  end
end
