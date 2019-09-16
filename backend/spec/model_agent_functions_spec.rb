require_relative 'spec_helper'

describe 'AgentFunction model' do
  it "allows agent_function records to be created" do
    function = AgentFunction.create_from_json(build(:json_agent_function))
    expect(AgentFunction[function[:id]]).to_not eq(nil)
  end
end
