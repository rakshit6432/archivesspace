require_relative 'spec_helper'

describe 'AgentOccupation model' do
  it "allows agent_occupation records to be created" do
    occupation = AgentOccupation.create_from_json(build(:json_agent_occupation))
    expect(AgentOccupation[occupation[:id]]).to_not eq(nil)
  end
end
