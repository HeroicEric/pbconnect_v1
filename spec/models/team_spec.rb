require 'spec_helper'

describe Team do

  before(:each) do
    @attr = {
      name: "Dynasty"
    }
  end

  it "should create a new instance given a valid attribute" do
    Team.create!(@attr)
  end

  describe "validations" do
    describe "name" do
      it "requires a name" do
        team = Team.new(@attr.merge(name: ""))
        team.should_not be_valid
      end

      it "requires a name" do
        team = Factory.build(:team, name: "")
        team.should_not be_valid
      end

      it "rejects names that are too long" do
        team = Team.new(@attr.merge(name: "a"*36))
        team.should_not be_valid
      end

      it "rejects names that are too short" do
        team = Team.new(@attr.merge(name: "aa"))
        team.should_not be_valid
      end

      it "rejects names that are duplicates" do
        original_team = Factory(:team, name: "Dynasty")
        duplicate_team = Factory.build(:team, name: "Dynasty")
        duplicate_team.should_not be_valid
      end
    end
  end

  describe "associations" do
    it "should have team_memberships attribute" do
      team = Team.create(@attr)
      team.should respond_to(:team_memberships)
    end

    it "should have players attribute" do
      team = Team.create(@attr)
      team.should respond_to(:players)
    end
  end

end
