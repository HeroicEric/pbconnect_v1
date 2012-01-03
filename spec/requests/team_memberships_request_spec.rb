require 'spec_helper'

describe "team_memberships request" do

  describe "#create" do
    before(:each) do
      @team = Factory(:team)
      @eric_admin = Factory(:user, name: "Eric Kelly")
      @fred = Factory(:user, name: "Fred Flinstone")
      RosterAddition.new(team: @team, member: @eric_admin, role: 'admin')
      login_user(@eric_admin)
      visit team_path(@team)
    end

    it "only gives the option to add users who on the team" do
      within "#team_membership_user_id" do
        page.should_not have_css("option[@value='#{@eric_admin.id}']")
        page.should have_css("option[@value='#{@fred.id}']")
      end
    end

    describe "success" do
      it "adds a member with role of player" do
        select @fred.name, from: "team_membership[user_id]"
        click_button "Add Member"
        current_path.should == team_path(@team)
        page.should have_content "#{@fred.name} was successfully added to the roster!"
        within("#roster .members") do
          page.should have_content @fred.name
        end
        @team.role_of(@fred).should == "player"
      end
    end
  end

end