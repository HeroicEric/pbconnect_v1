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
    before(:each) do @team = Factory(:team) end

    it "should have team_memberships attribute" do
      @team.should respond_to(:team_memberships)
    end

    it "should have members attribute" do
      @team.should respond_to(:members)
    end

    describe "admins" do
      it "has the admins attribute" do
        @team.should respond_to(:admins)
      end

      it "has the correct users as admins" do
        admin_user = Factory(:user)
        RosterAddition.new(team: @team, member: admin_user, role: 'admin')
        @team.admins.should include(admin_user)
      end
    end

    describe "#is_admin?" do
      before(:each) do
        @team = Factory(:team)
        @admin_user = Factory(:user)
        @non_admin_user = Factory(:user)
        RosterAddition.new(team: @team, member: @admin_user, role: 'admin')
        RosterAddition.new(team: @team, member: @non_admin_user, role: 'member')
      end

      it "returns whether or not the user is an admin of the team" do
        @team.is_admin?(@non_admin_user).should be_false
        @team.is_admin?(@admin_user).should be_true
      end

      it "returns false even if the user is not member of the team at all" do
        non_member_user = Factory(:user)
        @team.is_admin?(non_member_user).should == false
      end
    end

    describe "#role_of" do
      it "returns the role within the team for a given user" do
        @team = Factory(:team)
        @admin_user = Factory(:user)
        @member_user = Factory(:user)
        RosterAddition.new(team: @team, member: @admin_user, role: 'admin')
        RosterAddition.new(team: @team, member: @member_user, role: 'member')
        @team.role_of(@admin_user).should == 'admin'
        @team.role_of(@member_user).should == 'member'
      end
    end

    describe "#add_admin(user)" do
      it "makes the given user a team member with role of 'admin'" do
        @team = Factory(:team)
        @user = Factory(:user)
        @team.add_admin(@user)
        @team.members.should include(@user)
        @team.admins.should include(@user)
      end

      it "does nothing if the user is already an admin" do
        @team = Factory(:team)
        @user = Factory(:user)
        @team.add_admin(@user)
        @team.add_admin(@user)
        @team.team_memberships.where(user_id: @user.id).count.should == 1
      end
    end

    describe "#add_member(user, role: 'member')" do
      it "adds a user to the team with role of member" do
        @team = Factory(:team)
        @user = Factory(:user)
        @team.add_member(@user)
        @team.members.should include(@user)
        @team.admins.should_not include(@user)
      end
    end
  end

end
