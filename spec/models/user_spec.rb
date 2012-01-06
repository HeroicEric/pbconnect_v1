require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  describe ".not_on_team(team)" do
    it "returns all Users who are not Members of given Team" do
      team = Factory(:team)
      @team_user = Factory(:user)
      @teamless_user = Factory(:user)
      RosterAddition.new(team: team, member: @team_user)
      User.not_on_team(team).should include(@teamless_user)
      User.not_on_team(team).should_not include(@team_user)
    end

    it "returns all Users when the team has no members" do
      3.times do Factory(:user) end
      team = Factory(:team)
      User.not_on_team(team).should == User.all
    end
  end

  describe "#membership_with(team)" do
    it "gets the team membership that links the user with given team" do
      team = Factory(:team)
      user = Factory(:user)
      team.add_member(user)
      team_membership = team.team_memberships.where(user_id: user.id).first
      user.membership_with(team).should == team_membership
    end
  end

  it "creates a new instance given a valid attribute" do
    User.create!(@attr)
  end

  it "requires an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "requires a valid email address" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "rejects invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "rejects duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "rejects email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

  end

  describe "follows" do
    it "gets an array of ids for objects that it is following" do
      @eric = Factory(:user)
      @fred = Factory(:user)
      @matt = Factory(:user)
      @eric.follow(@fred)
      @eric.following_type_ids('User').include?(@fred.id).should be_true
      @eric.following_type_ids('User').include?(@matt.id).should be_false
    end
  end

  describe "associations" do
    before(:each) do
      @user = Factory(:user)
      @team = Factory(:team)
      @team.add_member(@user)
      @team_membership = TeamMembership.where(team_id: @team.id, user_id: @user.id).first
    end

    it "has the team_memberships attribute" do
      @user.should respond_to(:team_memberships)
    end

    it "has the corrent team_memberships" do
      @user.team_memberships.should include(@team_membership)
    end

    it "has teams" do
      @user.should respond_to(:teams)
    end

    it "should have the right teams" do
      @team2 = Factory(:team)
      @user.teams.should include(@team)
      @user.teams.should_not include(@team2)
    end
  end

  describe "update associations" do

    before(:each) do
      @user = User.create!(@attr)
      @update1 = Factory(:update, user: @user, created_at: 1.hour.ago)
      @update2 = Factory(:update, user: @user, created_at: 3.hours.ago)
      @update3 = Factory(:update, user: @user, created_at: 2.hours.ago)
    end

    it "should have updates attribute" do
      @user.should respond_to(:updates)
    end

    it "returns the correct updates in the correct order" do
      @user.updates.should == [@update1, @update3, @update2]
    end

    it "destroys associated updates when destroyed" do
      @user.destroy
      [@update1, @update2, @update3].each do |update|
        Update.find_by_id(update.id).should be_nil
      end
    end

    describe "update feed" do

      it "has a feed" do
        @user.should respond_to(:feed)
      end

      it "includes the user's updates" do
        @user.feed.include?(@update1).should be_true
        @user.feed.include?(@update2).should be_true
        @user.feed.include?(@update3).should be_true
      end

      it "shouldn't include other user's updates that user is not following" do
        @other_user = Factory(:user)
        @other_user_update = Factory(:update, user: @other_user)
        @user.following?(@other_user).should == false
        @user.feed.include?(@other_user_update).should_not be_true
      end

      it "includes updates by those that the user is following" do
        @fred = Factory(:user)
        @bill = Factory(:user)
        @fred_update = Factory(:update, user: @fred)
        @bill_update = Factory(:update, user: @bill)
        @user.follow(@fred)
        @user.feed.include?(@fred_update).should be_true
        @user.feed.include?(@bill_update).should be_false
      end
    end
  end
end