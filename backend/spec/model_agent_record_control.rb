require_relative 'spec_helper'

describe 'AgentRecordControl model' do

  it "allows accessions to be created" do
  	json = build(:agent_record_control)

    puts "++++++++++++++++++++++++++++++"
    puts json.inspect

    arc = AgentRecordControl.create_from_json(json)

    puts "++++++++++++++++++++++++++++++"
    puts arc.inspect
  end
end
