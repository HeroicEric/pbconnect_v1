class Team < ActiveRecord::Base
  attr_accessible :name

  has_many :team_memberships, :dependent => :destroy
  has_many :members, :through => :team_memberships

  has_many :admins,
    :class_name  => 'User',
    :conditions  => ['team_memberships.role = ?', 'admin'],
    :through     => :team_memberships,
    :foreign_key => 'user_id',
    :source      => :member

  has_many :active_users,
    :class_name  => 'User',
    :conditions  => ['team_memberships.role IN (?)', %w{admin member}],
    :through     => :team_memberships,
    :foreign_key => 'user_id',
    :source      => :member

  validates :name, presence: true, length: { in: 3..35 }, uniqueness: true

  def add_admin(user)
    team_memberships.create(user_id: user.id, role: 'admin')
  end

  def add_member(user)
    TeamMembership.create(team_id: id, user_id: user.id, role: 'member')
  end

  def role_of(user)
    team_memberships.find_by_user_id(user.id).role
  end

  def is_admin?(user)
    if members.include?(user)
      role_of(user) == "admin"
    else
      false
    end
  end
end