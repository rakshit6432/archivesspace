require_relative 'spec_helper'

describe 'AgentDate model' do
  describe "single dates" do
    it "creates single agent_date records with expressions" do
      ad = AgentDate.new(:date_label => "creation",
                         :date_type_enum => "single",
                         :date_role_enum => "begin",
                         :begin_date_expression => "Yesterday")

      ad.save
      expect(ad.valid?).to eq(true)
    end

    it "creates single agent_date records with standardized dates" do
      ad = AgentDate.new(:date_label => "creation",
                         :date_type_enum => "single",
                         :date_role_enum => "begin",
                         :begin_date_standardized => Time.now)
  
      ad.save
      expect(ad.valid?).to eq(true)
    end

    it "creates single agent_date records with expressions for end dates" do
      ad = AgentDate.new(:date_label => "creation",
                         :date_type_enum => "single",
                         :date_role_enum => "end",
                         :end_date_expression => "Tomorrow")

      ad.save
      expect(ad.valid?).to eq(true)
    end

    it "creates single agent_date records with standardized dates for end dates" do
      ad = AgentDate.new(:date_label => "creation",
                         :date_type_enum => "single",
                         :date_role_enum => "end",
                         :end_date_standardized => Time.now)
  
      ad.save
      expect(ad.valid?).to eq(true)
    end

    it "requires single dates to specify a role" do
      ad = AgentDate.new(:date_label => "creation",
                         :date_type_enum => "single",
                         :begin_date_standardized => Time.now)
  
      expect(ad.valid?).to eq(false)
    end

    it "requires single begin dates to specify a begin time" do
      ad = AgentDate.new(:date_label => "creation",
                         :date_type_enum => "single",
                         :date_role_enum => "begin",
                         :end_date_standardized => Time.now)
  
      expect(ad.valid?).to eq(false)
    end

    it "requires single end dates to specify a begin time" do
      ad = AgentDate.new(:date_label => "creation",
                         :date_type_enum => "single",
                         :date_role_enum => "end",
                         :begin_date_standardized => Time.now)
  
      expect(ad.valid?).to eq(false)
    end
  end

  describe "ranged dates" do
    it "creates ranged agent_date records with expressions" do
      ad = AgentDate.new(:date_label => "creation",
                         :date_type_enum => "range",
                         :date_role_enum => "begin",
                         :begin_date_expression => "Yesterday",
                         :end_date_expression => "Tomorow")

      ad.save
      expect(ad.valid?).to eq(true)
    end

    it "creates ranged agent_date records with standardized dates" do
      ad = AgentDate.new(:date_label => "creation",
                         :date_type_enum => "range",
                         :date_role_enum => "begin",
                         :begin_date_standardized => "2018-01-01 00:00:00",
                         :end_date_standardized => "2018-03-01 12:00:00")

      ad.save
      expect(ad.valid?).to eq(true)
    end

    it "creates ranged agent_date records with a mix of standardized and ranged dates" do
      ad = AgentDate.new(:date_label => "creation",
                         :date_type_enum => "range",
                         :date_role_enum => "begin",
                         :begin_date_expression => "Sometime in the stone age",
                         :end_date_standardized => "2018-03-01 12:00:00")

      ad.save
      expect(ad.valid?).to eq(true)
    end

    it "creates ranged agent_date records with a mix of dates (end is expression)" do
      ad = AgentDate.new(:date_label => "creation",
                         :date_type_enum => "range",
                         :date_role_enum => "begin",
                         :begin_date_standardized => "2018-01-01 00:00:00",
                         :end_date_expression => "Before the sun goes nova")

      ad.save
      expect(ad.valid?).to eq(true)
    end

    it "requires ranged dates to have a begin date" do
      ad = AgentDate.new(:date_label => "creation",
                         :date_type_enum => "range",
                         :date_role_enum => "begin",
                         :end_date_expression => "Before the sun goes nova")

      expect(ad.valid?).to eq(false)
    end

    it "requires ranged dates to have an end date" do
      ad = AgentDate.new(:date_label => "creation",
                         :date_type_enum => "range",
                         :date_role_enum => "begin",
                         :begin_date_expression => "Before the big bang")

      expect(ad.valid?).to eq(false)
    end
  end
end
