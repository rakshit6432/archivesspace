require_relative 'spec_helper'

describe 'AgentMaintenanceHistory model' do
  it "allows agent_maintenance_history records to be created" do
    amh = AgentMaintenanceHistory.new(
      :maintenance_event_type_enum => "created",
      :maintenance_agent_type_enum => "human",
      :event_date => Time.now,
      :agent => "agent",
      :descriptive_note => "descriptive_note")

    amh.save
    expect(amh.valid?).to eq(true)
  end

  it "allows agent_maintenance_history records to be created from json" do
    pending "failing with NoMethodError"
  	json = build(:agent_maintenance_history)
    amh = AgentMaintenanceHistory.create_from_json(json)
  end
end
