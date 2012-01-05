require 'spec_helper'

describe "team_memberships request" do

  describe "GET /team" do
    before(:each) do
      @team = Factory(:team)
      @admin = Factory(:user)
      @player = Factory(:user)
      @team.add_admin(@admin)
      login_user(@admin)
      visit team_path(@team)
    end

    it "gives the option to add users who are not on the team" do
      within "#team_membership_user_id" do
        page.should_not have_css("option[@value='#{@admin.id}']")
        page.should have_css("option[@value='#{@player.id}']")
      end
    end
  end

  describe "POST /team_memberships" do
    it "fails unless current user is an admin for the team" do
      @team = Factory(:team)
      @user = Factory(:user)
      @player = Factory(:user)
      @team.add_player(@player)
      login_user(@player)
      visit team_path(@team)
      select @user.name, from: "team_membership[user_id]"
      click_button "Add Member"
      page.should have_content "You are not allowed to add members to this team."
      current_path.should == team_path(@team)
      within("#roster .members") do
        page.should_not have_content @user.name
      end
    end

    describe "success" do
      it "adds a member with role of player" do
        @team = Factory(:team)
        @admin = Factory(:user)
        @player = Factory(:user)
        @team.add_admin(@admin)
        login_user(@admin)
        visit team_path(@team)
        select @player.name, from: "team_membership[user_id]"
        click_button "Add Member"
        current_path.should == team_path(@team)
        page.should have_content "#{@player.name} was successfully added to the roster!"
        within("#roster .members") do
          page.should have_content @player.name
        end
        @team.role_of(@player).should == "player"
      end
    end
  end

  describe "DELETE /team_membership" do

    it "fails if current_user is not an admin for the team" do
      @user = Factory(:user)
      @team = Factory(:team)
      @player = Factory(:user)
      @team.add_player(@player)
      login_user(@user)
      @team.is_admin?(@user).should == false
      visit team_path(@team)
      within "#member-#{@player.id}" do
        find("input[@rel='delete-team-membership']").click
      end
      page.should have_content "You are not allowed to remove members from this team."
    end

    it "deletes the team_membership of a player" do
      @team = Factory(:team)
      @admin = Factory(:user)
      @player = Factory(:user)
      @team.add_admin(@admin)
      @team.add_player(@player)
      login_user(@admin)
      visit team_path(@team)
      within "#member-#{@player.id}" do
        find("input[@rel='delete-team-membership']").click
      end
      page.should have_content "User was successfully removed!"
      @team.members.should_not include(@player)
    end
  end
end