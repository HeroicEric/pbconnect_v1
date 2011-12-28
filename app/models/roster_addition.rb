class RosterAddition
  def initialize(options={})
    if options[:team].players.empty?
      options[:role] ||= 'admin'
    else
      options[:role] ||= 'player'
    end

    TeamMembership.create(
      team_id: options[:team].id,
      user_id: options[:player].id,
      role: options[:role]
    )
  end
end