class TeamMembership < ActiveRecord::Base
  ROLES = %w{admin member}

  belongs_to :team
  belongs_to :member, class_name: 'User', foreign_key: 'user_id'

  validates :user_id,
    presence: true,
    uniqueness: { :scope => :team_id }

  validates :team_id, presence: true
  validates :role,    presence: true
  validates_inclusion_of :role, in: ROLES
end