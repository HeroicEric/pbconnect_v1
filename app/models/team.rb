class Team < ActiveRecord::Base
  attr_accessible :name

  has_many :team_memberships, :dependent => :destroy
  has_many :members, :through => :team_memberships

  has_many :admins,
    :class_name => 'User',
    :conditions => ['team_memberships.role = ?', 'admin'],
    :through => :team_memberships,
    :foreign_key => 'user_id',
    :source => :member

  validates :name, presence: true, length: { in: 3..35 }, uniqueness: true

  def add_admin(user)
    TeamMembership.create(team_id: id, user_id: user.id, role: 'admin')
  end

  def add_player(user)
    TeamMembership.create(team_id: id, user_id: user.id, role: 'player')
  end

  def role_of(user)
    team_memberships.find_by_user_id(user.id).role
  end

  def is_admin?(user)
    role_of(user) == "admin"
  end
end