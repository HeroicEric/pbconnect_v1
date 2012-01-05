class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:create, :update, :destroy], TeamMembership do |team_membership|
      Team.find(team_membership.team_id).is_admin?(user)
    end
  end
end
