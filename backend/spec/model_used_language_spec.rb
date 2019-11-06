require_relative 'spec_helper'

describe 'AgentGender model' do
  it "allows used_language records to be created" do
    ul = UsedLanguage.create_from_json(build(:json_used_language))
    expect(UsedLanguage[ul[:id]]).to_not eq(nil)
  end

  it "expects a used language to have either a language or a note" do
  	pending
	end
end
