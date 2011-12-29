require 'spec_helper'

describe RosterAddition do
  it "adds a user to a team as a player" do
    team = Factory(:team)
    user = Factory(:user)
    RosterAddition.new(team: team, member: user)
    team.members.should include(user)
  end

  context "user is the first player on team" do
    it 'adds User as admin' do
      team = Factory(:team)
      user = Factory(:user)
      RosterAddition.new(team: team, member: user)
      team_membership = TeamMembership.where(user_id: user.id).first
      team_membership.role.should == 'admin'
    end
  end

  context "there is already at least one admin on the team" do
    it 'adds User as player if no role is given' do
      team = Factory(:team)
      admin = Factory(:user)
      user = Factory(:user)
      RosterAddition.new(team: team, member: admin)
      RosterAddition.new(team: team, member: user)
      team_membership = TeamMembership.where(user_id: user.id).first
      team_membership.role.should == 'player'
    end
  end
end