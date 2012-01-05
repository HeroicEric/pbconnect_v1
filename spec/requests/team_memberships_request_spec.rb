require 'spec_helper'

describe "team_memberships request" do

  describe "GET /team" do
    before(:each) do
      @team = Factory(:team)
      @admin = Factory(:user)
      @member = Factory(:user)
      @team.add_admin(@admin)
      login_user(@admin)
      visit team_path(@team)
    end

    it "gives the option to add users who are not on the team" do
      within "#team_membership_user_id" do
        page.should_not have_css("option[@value='#{@admin.id}']")
        page.should have_css("option[@value='#{@member.id}']")
      end
    end
  end

  describe "POST /team_memberships" do
    it "fails unless current user is an admin for the team" do
      @team = Factory(:team)
      @user = Factory(:user)
      @member = Factory(:user)
      @team.add_member(@member)
      login_user(@member)
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
      it "adds a member with role of member" do
        @team = Factory(:team)
        @admin = Factory(:user)
        @member = Factory(:user)
        @team.add_admin(@admin)
        login_user(@admin)
        visit team_path(@team)
        select @member.name, from: "team_membership[user_id]"
        click_button "Add Member"
        current_path.should == team_path(@team)
        page.should have_content "#{@member.name} was successfully added to the roster!"
        within("#roster .members") do
          page.should have_content @member.name
        end
        @team.role_of(@member).should == "member"
      end
    end
  end

  describe "DELETE /team_membership" do

    it "fails if current_user is not an admin for the team" do
      @user = Factory(:user)
      @team = Factory(:team)
      @member = Factory(:user)
      @team.add_member(@member)
      login_user(@user)
      @team.is_admin?(@user).should == false
      visit team_path(@team)
      within "#member-#{@member.id}" do
        find("input[@rel='delete-team-membership']").click
      end
      page.should have_content "You are not allowed to remove members from this team."
    end

    it "deletes the team_membership of a member" do
      @team = Factory(:team)
      @admin = Factory(:user)
      @member = Factory(:user)
      @team.add_admin(@admin)
      @team.add_member(@member)
      login_user(@admin)
      visit team_path(@team)
      within "#member-#{@member.id}" do
        find("input[@rel='delete-team-membership']").click
      end
      page.should have_content "User was successfully removed!"
      @team.members.should_not include(@member)
    end
  end

  describe "PUT /team_membership" do
    context "from the show team page" do
      it "denies access if user is not an admin for team" do
        @team = Factory(:team)
        @member1 = Factory(:user)
        @member2 = Factory(:user)
        @team.add_member(@member1)
        @team.add_member(@member2)
        @team.is_admin?(@member1).should be_false
        login_user(@member1)
        visit team_path(@team)
        within "#member-#{@member2.id}" do
          click_button "Make Admin"
        end
        page.should have_css(".alert-message.warning")
        @team.is_admin?(@member).should be_false
      end

      it "promotes a user to an admin" do
        @team = Factory(:team)
        @admin = Factory(:user)
        @member = Factory(:user)
        @team.add_admin(@admin)
        @team.add_member(@member)
        @team.is_admin?(@member).should be_false
        login_user(@admin)
        visit team_path(@team)
        within "#member-#{@member.id}" do
          click_button "Make Admin"
        end
        page.should have_css(".alert-message.success")
        @team.is_admin?(@member).should be_true
      end
    end
  end
end