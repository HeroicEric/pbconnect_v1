class RosterAddition
  def initialize(options={})
    if options[:team].members.empty?
      options[:role] ||= 'admin'
    else
      options[:role] ||= 'player'
    end

    TeamMembership.create(
      team_id: options[:team].id,
      user_id: options[:member].id,
      role: options[:role]
    )
  end
end