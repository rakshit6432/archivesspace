require 'spec_helper'

describe 'Merge request controller' do

  def get_merge_request_detail_json(target, victim, selections)

    request = JSONModel(:merge_request_detail).new
    request.target = {'ref' => target.uri}
    request.victims = [{'ref' => victim.uri}]
    request.selections = selections

    return request
  end

  it "can merge two subjects" do
    target = create(:json_subject)
    victim = create(:json_subject)

    request = JSONModel(:merge_request).new
    request.target = {'ref' => target.uri}
    request.victims = [{'ref' => victim.uri}]

    request.save(:record_type => 'subject')

    expect {
      JSONModel(:subject).find(victim.id)
    }.to raise_error(RecordNotFound)
  end


  it "doesn't mess things up if you merge something with itself" do
    target = create(:json_subject)

    request = JSONModel(:merge_request).new
    request.target = {'ref' => target.uri}
    request.victims = [{'ref' => target.uri}]

    request.save(:record_type => 'subject')

    expect {
      JSONModel(:subject).find(target.id)
    }.not_to raise_error
  end


  it "throws an error if you ask it to merge something other than a subject" do
    target = create(:json_subject)
    victim = create(:json_agent_person)

    request = JSONModel(:merge_request).new
    request.target = {'ref' => target.uri}
    request.victims = [{'ref' => victim.uri}]

    expect {
      request.save(:record_type => 'subject')
    }.to raise_error(JSONModel::ValidationException)
  end



  it "can merge two resources" do
    target = create(:json_resource)
    victim = create(:json_resource)

    victim_ao = create(:json_archival_object,
                       :resource => {'ref' => victim.uri})

    request = JSONModel(:merge_request).new
    request.target = {'ref' => target.uri}
    request.victims = [{'ref' => victim.uri}]

    request.save(:record_type => 'resource')

    # Victim is gone
    expect {
      JSONModel(:resource).find(victim.id)
    }.to raise_error(RecordNotFound)

    # The children were moved
    merged_tree = JSONModel(:resource_tree).find(nil, :resource_id => target.id)
    expect(merged_tree.children.any? {|child| child['record_uri'] == victim_ao.uri}).to be_truthy

    # An event was created
    expect(Event.this_repo.all.any? {|event|
      expect(event.outcome_note).to match(/#{victim.title}/)
    }).to be_truthy
  end


  it "can merge two digital objects" do
    target = create(:json_digital_object)
    victim = create(:json_digital_object)

    victim_doc = create(:json_digital_object_component,
                        :digital_object => {'ref' => victim.uri})

    request = JSONModel(:merge_request).new
    request.target = {'ref' => target.uri}
    request.victims = [{'ref' => victim.uri}]

    request.save(:record_type => 'digital_object')

    # Victim is gone
    expect {
      JSONModel(:digital_object).find(victim.id)
    }.to raise_error(RecordNotFound)

    # The children were moved
    merged_tree = JSONModel(:digital_object_tree).find(nil, :digital_object_id => target.id)
    expect(merged_tree.children.any? {|child| child['record_uri'] == victim_doc.uri}).to be_truthy

    # An event was created
    expect(Event.this_repo.all.any? {|event|
      expect(event.outcome_note).to match(/#{victim.title}/)
    }).to be_truthy
  end

  describe "merging agents" do
    it "can merge two agents" do
      target = create(:json_agent_person)
      victim = create(:json_agent_person)

      request = JSONModel(:merge_request).new
      request.target = {'ref' => target.uri}
      request.victims = [{'ref' => victim.uri}]

      request.save(:record_type => 'agent')

      expect {
        JSONModel(:agent_person).find(victim.id)
      }.to raise_error(RecordNotFound)
    end


    it "can merge two agents of different types" do
      target = create(:json_agent_person)
      victim = create(:json_agent_corporate_entity)

      request = JSONModel(:merge_request).new
      request.target = {'ref' => target.uri}
      request.victims = [{'ref' => victim.uri}]

      request.save(:record_type => 'agent')

      expect {
        JSONModel(:agent_corporate_entity).find(victim.id)
      }.to raise_error(RecordNotFound)
    end

    # In the tests below, selection hash order will determine which subrec in target is replaced
    # For example, in a replace operation the contents of selection[n] will replace target[subrecord][n]
    # Some of these tests simulate a replacement of selection[0] to target[subrecord][0]
    # Others simulate selection[1] to target[subrecord][1]

    it "can replace entire subrecord on merge" do
      target = create(:json_agent_person_merge_target)
      victim = create(:json_agent_person_merge_victim)
      subrecord = victim["agent_conventions_declarations"][0]

      selections = {
        'agent_conventions_declarations' => [
          {
            'replace' => "REPLACE",
            'id' => subrecord["id"].to_i
          }
        ]
      }

      merge_request = get_merge_request_detail_json(target, victim, selections)
      merge_request.save(:record_type => 'agent_detail')

      target_record = JSONModel(:agent_person).find(target.id)
      replaced_subrecord = target_record['agent_conventions_declarations'][0]

      replaced_subrecord.each_key do |k|
        next if k == "id" || k == "agent_person_id" || k =~ /time/
        expect(replaced_subrecord[k]).to eq(subrecord[k])
      end

      expect {
        JSONModel(:agent_person).find(victim.id)
      }.to raise_error(RecordNotFound)
    end

    it "can append entire subrecord on merge" do
      target = create(:json_agent_person_merge_target)
      victim = create(:json_agent_person_merge_victim)
      subrecord = victim["agent_conventions_declarations"][0]
      target_subrecord_count = target['agent_conventions_declarations'].length

      selections = {
        'agent_conventions_declarations' => [
          {
            'append' => "REPLACE",
            'id' => subrecord["id"].to_i
          },
        ]
      }

      merge_request = get_merge_request_detail_json(target, victim, selections)
      merge_request.save(:record_type => 'agent_detail')

      target_record = JSONModel(:agent_person).find(target.id)
      appended_subrecord = target_record['agent_conventions_declarations'].last

      expect(target_record['agent_conventions_declarations'].length).to eq(target_subrecord_count += 1)

      appended_subrecord.each_key do |k|
        next if k == "id" || k == "agent_person_id" || k =~ /time/
        expect(appended_subrecord[k]).to eq(subrecord[k])
      end

      expect {
        JSONModel(:agent_person).find(victim.id)
      }.to raise_error(RecordNotFound)     
    end

    it "can replace field in subrecord on merge" do
      target = create(:json_agent_person_merge_target)
      victim = create(:json_agent_person_merge_victim)
      target_subrecord = target["agent_record_controls"][0]
      victim_subrecord = victim["agent_record_controls"][0]

      selections = {
        'agent_record_controls' => [
          {
            'maintenance_agency' => "REPLACE",
            'id' => victim_subrecord["id"].to_i
          }
        ]
      }

      merge_request = get_merge_request_detail_json(target, victim, selections)
      merge_request.save(:record_type => 'agent_detail')

      target_record = JSONModel(:agent_person).find(target.id)
      replaced_subrecord = target_record['agent_record_controls'][0]

      # replaced field
      expect(replaced_subrecord['maintenance_agency']).to eq(victim_subrecord['maintenance_agency'])

      # other fields in subrec should stay the same as before
      replaced_subrecord.each_key do |k|
        next if k == "id" || k == "maintenance_agency" || k =~ /time/
        expect(replaced_subrecord[k]).to eq(target_subrecord[k])
      end

      expect {
        JSONModel(:agent_person).find(victim.id)
      }.to raise_error(RecordNotFound)
    end

    it "can replace entire subrecord on merge when order is changed" do
      target = create(:json_agent_person_merge_target)
      victim = create(:json_agent_person_merge_victim)
      subrecord = victim["agent_conventions_declarations"][0]

 
      selections = {
        'agent_conventions_declarations' => [
          {
            'id' => victim["agent_conventions_declarations"][1]["id"]
          },
          {
            'replace' => "REPLACE",
            'id' => subrecord["id"].to_i
          }
        ]
      }

      merge_request = get_merge_request_detail_json(target, victim, selections)
      merge_request.save(:record_type => 'agent_detail')

      target_record = JSONModel(:agent_person).find(target.id)
      replaced_subrecord = target_record['agent_conventions_declarations'][1]

      replaced_subrecord.each_key do |k|
        next if k == "id" || k == "agent_person_id" || k =~ /time/
        expect(replaced_subrecord[k]).to eq(subrecord[k])
      end

      expect {
        JSONModel(:agent_person).find(victim.id)
      }.to raise_error(RecordNotFound)
    end

    it "can append entire subrecord on merge when order is changed" do
      target = create(:json_agent_person_merge_target)
      victim = create(:json_agent_person_merge_victim)
      subrecord = victim["agent_conventions_declarations"][0]
      target_subrecord_count = target['agent_conventions_declarations'].length

      selections = {
        'agent_conventions_declarations' => [
          {
            'id' => victim["agent_conventions_declarations"][1]["id"].to_i
          },
          {
            'append' => "REPLACE",
            'id' => subrecord["id"].to_i
          },
        ]
      }

      merge_request = get_merge_request_detail_json(target, victim, selections)
      merge_request.save(:record_type => 'agent_detail')

      target_record = JSONModel(:agent_person).find(target.id)
      appended_subrecord = target_record['agent_conventions_declarations'].last

      expect(target_record['agent_conventions_declarations'].length).to eq(target_subrecord_count += 1)

      appended_subrecord.each_key do |k|
        next if k == "id" || k == "agent_person_id" || k =~ /time/
        expect(appended_subrecord[k]).to eq(subrecord[k])
      end

      expect {
        JSONModel(:agent_person).find(victim.id)
      }.to raise_error(RecordNotFound)
    end

    it "can replace field in subrecord on merge when order is changed" do
      target = create(:json_agent_person_merge_target)
      victim = create(:json_agent_person_merge_victim)
      target_subrecord = target["agent_conventions_declarations"][1]
      victim_subrecord = victim["agent_conventions_declarations"][0]

      selections = {
        'agent_conventions_declarations' => [
          {
            'id' => victim["agent_conventions_declarations"][1]["id"].to_i
          },
          {
            'descriptive_note' => "REPLACE",
            'id' => victim_subrecord["id"].to_i
          }
        ]
      }

      merge_request = get_merge_request_detail_json(target, victim, selections)
      merge_request.save(:record_type => 'agent_detail')

      target_record = JSONModel(:agent_person).find(target.id)
      replaced_subrecord = target_record['agent_conventions_declarations'][1]

      # replaced field
      expect(replaced_subrecord['descriptive_note']).to eq(victim_subrecord['descriptive_note'])

      # other fields in subrec should stay the same as before
      replaced_subrecord.each_key do |k|
        next if k == "id" || k == "descriptive_note" || k =~ /time/
        expect(replaced_subrecord[k]).to eq(target_subrecord[k])
      end

      expect {
        JSONModel(:agent_person).find(victim.id)
      }.to raise_error(RecordNotFound)
    end
  end
end
