require 'spec_helper'

describe 'Software agent controller' do

  def create_software(opts = {})
    create(:json_agent_software, opts)
  end


  it "lets you create a software agent and get them back" do
    opts = {:names => [build(:json_name_software, :manufacturer => generate(:generic_name))]}

    id = create_software(opts).id
    expect(JSONModel(:agent_software).find(id).names.first['manufacturer']).to eq(opts[:names][0]['manufacturer'])
  end


  it "lets you update a software agent" do
    id = create_software(:agent_contacts => nil).id

    software = JSONModel(:agent_software).find(id)
    [0,1].each do |n|
      opts = {:name => generate(:generic_name)}

      software.agent_contacts << build(:json_agent_contact, opts)
      software.save

      expect(JSONModel(:agent_software).find(id).agent_contacts[n]['name']).to eq(opts[:name])
    end
  end


  it "can give a list of software agents" do
    start = JSONModel(:agent_software).all(:page => 1)['results'].count

    2.times { create_software }

    expect(JSONModel(:agent_software).all(:page => 1)['results'].count).to eq(start+2)
  end


  it "sets the sort name if one is provided" do
    opts = {:names => [build(:json_name_software, :sort_name => "Custom Sort Name", :sort_name_auto_generate => false)]}

    id = create_software(opts).id
    expect(JSONModel(:agent_software).find(id).names.first['sort_name']).to eq(opts[:names][0]['sort_name'])
  end


  it "auto-generates the sort name if one is not provided" do
    id = create_software({:names => [build(:json_name_software,{:software_name => "ArchivesSpace", :sort_name_auto_generate => true})]}).id

    agent = JSONModel(:agent_software).find(id)

    expect(agent.names.first['sort_name']).to eq("ArchivesSpace")

    agent.names.first['version'] = "1.0"
    agent.save

    expect(JSONModel(:agent_software).find(id).names.first['sort_name']).to eq("ArchivesSpace 1.0")

  end

  it "creates agent subrecords if appropriate" do
    agent_with_subrecs = build(:json_agent_software_full_subrec)  

    url = URI("#{JSONModel::HTTP.backend_url}/agents/software")
    response = JSONModel::HTTP.post_json(url, agent_with_subrecs.to_json)

    json_response = ASUtils.json_parse(response.body)

    expect(json_response["status"]).to eq("Created")
    agent_id = json_response["id"]

    expect(AgentRecordControl.where(:agent_software_id => agent_id).count).to eq(1)
    expect(AgentAlternateSet.where(:agent_software_id => agent_id).count).to eq(1)
    expect(AgentConventionsDeclaration.where(:agent_software_id => agent_id).count).to eq(1)
    expect(AgentSources.where(:agent_software_id => agent_id).count).to eq(1)
    expect(AgentOtherAgencyCodes.where(:agent_software_id => agent_id).count).to eq(1)
    expect(AgentMaintenanceHistory.where(:agent_software_id => agent_id).count).to eq(1)
    expect(AgentRecordIdentifier.where(:agent_software_id => agent_id).count).to eq(1)
  end

end
