require 'spec_helper'

describe "teams request" do

  describe "POST /team" do
    context "an authorized user" do
      before(:each) do
        @user = Factory(:user)
        login_user(@user)
      end

      it "creates a team if given valid information" do
        visit new_team_path
        fill_in "Name", with: "Dynasty"
        click_button "Save"
        page.should have_content "Team Dynasty was created successfully!"
        Team.find_by_name("Dynasty").should_not be_nil
      end

      it "adds the current user to the roster with admin privelages" do
        current_user = @user
        visit new_team_path
        fill_in "Name", with: "Dynasty"
        click_button "Save"
        team = Team.find_by_name("Dynasty")
        team.members.where("team_memberships.role = 'admin'").should include(current_user)
      end
    end
  end

  describe "GET /teams" do
    context "on the team index page" do
      context "if there are teams in the database" do
        it "lists links to all of the teams' show pages" do
          @teams = []
          5.times{ @teams << Factory(:team) }
          visit teams_path
          @teams.each do |team|
            page.should have_link(team.name, href: team_path(team))
          end
        end
      end

      context "there are no teams in the database" do
        it "displays a descriptive message" do
          Team.all.should be_empty
          visit teams_path
          page.should have_content "There are no teams yet."
        end
      end
    end
  end

  describe "GET /team" do
    context "for everybody" do
      before(:each) do
        @team = Factory(:team)
        3.times{ RosterAddition.new(team: @team, member: Factory(:user)) }
        visit team_path(@team)
      end

      it "lists the members" do
        @team.members.each do |member|
          page.should have_content member.name
        end
      end

      it "lists links to all players profiles" do
        @team.members.each do |member|
          page.should have_link(member.name, href: user_path(member))
        end
      end

      context "user is admin" do
        describe "showing the admninistrative actions" do

          describe "remove member button" do
            it "shows the remove member button" do
              @team.active_users.each do |user|
                within("#member-#{user.id}") do
                  page.should have_css("input[@rel='delete-team-membership']")
                end
              end
            end
          end

          it "shows the 'make admin' button for users that are not admins" do
            @team.active_users.each do |user|
              within("#member-#{user.id}") do
                if @team.is_admin?(user)
                  page.should_not have_css("input[@rel='make-admin']")
                else
                  page.should have_css("input[@rel='make-admin']")
                end
              end
            end
          end
        end
      end

    end
  end
end