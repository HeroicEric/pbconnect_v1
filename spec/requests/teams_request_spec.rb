require 'spec_helper'

describe "teams request" do

  describe "creating a team" do
    context "an authorized user" do
      before(:each) do
        @user = Factory(:user)
        login_user(@user)
      end

      it "creates a team with valid information" do
        visit new_team_path
        fill_in "Name", with: "Dynasty"
        click_button "Save"
        page.should have_content "Team Dynasty was created successfully!"
        Team.find_by_name("Dynasty").should_not be_nil
      end

      it "adds the current user to the roster as admin" do
        current_user = @user
        visit new_team_path
        fill_in "Name", with: "Dynasty"
        click_button "Save"
        team = Team.find_by_name("Dynasty")
        team.players.where("team_memberships.role = 'admin'").should include(current_user)
      end
    end
  end

  describe "listing teams" do
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

  describe "viewing a team" do

    before(:each) do
      @team = Factory(:team)
      3.times{ RosterAddition.new(team: @team, player: Factory(:user)) }
      visit team_path(@team)
    end

    it "lists the players" do
      @team.players.each do |player|
        page.should have_content player.name
      end
    end

    it "lists links to all players profiles" do
      @team.players.each do |player|
        page.should have_link(player.name, href: user_path(player))
      end
    end
  end
end