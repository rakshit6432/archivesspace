require_relative 'spec_helper'

describe 'AgentPlace model' do
  it "allows agent_place records to be created" do
    s = build(:json_subject).uri

    place = AgentPlace.create_from_json(build(:json_agent_place))
    expect(AgentPlace[place[:id]]).to_not eq(nil)
  end
end
