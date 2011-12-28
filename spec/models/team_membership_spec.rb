require 'spec_helper'

describe TeamMembership do

  before(:each) do
    @user = Factory(:user)
    @team = Factory(:team)

    @attr = {
      player: @user,
      team: @team,
      role: 'player'
    }
  end

  describe "validations" do
    it "creates an instance of itself when given valid attributes" do
      TeamMembership.create!(@attr)
    end

    it "requires a role" do
      @team_membership = TeamMembership.new(@attr.merge(role: nil))
      @team_membership.should_not be_valid
    end
  end

  describe "associations" do

    before(:each) do
      @team_membership = TeamMembership.create(@attr)
    end

    describe "team association" do
      it "has the team attribute" do
        @team_membership.should respond_to :team
      end

      it "has the correct team" do
        @team_membership.team.should == @team
      end

      it "is destroyed when team is destroyed" do
        @team.destroy
        TeamMembership.all.should_not include(@team_membership)
      end
    end

    describe "player association" do
      it "has the player attribute" do
        @team_membership.should respond_to :player
      end

      it "has the correct player" do
        @team_membership.player.should == @user
      end
    end
  end

end
