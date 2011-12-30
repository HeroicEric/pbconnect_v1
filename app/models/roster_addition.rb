class RosterAddition
  def initialize(options={})
    if options[:team].members.empty?
      options[:role] ||= 'admin'
    else
      options[:role] ||= 'player'
    end

    TeamMembership.create!(options)
  end
end