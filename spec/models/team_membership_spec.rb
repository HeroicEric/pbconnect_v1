require 'spec_helper'

describe TeamMembership do

  before(:each) do
    @user = Factory(:user)
    @team = Factory(:team)

    @attr = {
      team: @team,
      member: @user,
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

    it "requires that the user_id and team_id combo be unique" do
      original_tm = Factory(:team_membership, team_id: @team.id, user_id: @user.id)
      duplicate_tm = Factory.build(:team_membership, team_id: @team.id, user_id: @user.id)
      duplicate_tm.should_not be_valid
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

    describe "member association" do
      it "has the member attribute" do
        @team_membership.should respond_to :member
      end

      it "has the correct member" do
        @team_membership.member.should == @user
      end
    end
  end

  describe "#create" do
    describe "failure" do

    end
  end

end
