class TeamMembership < ActiveRecord::Base
  belongs_to :team
  belongs_to :member, class_name: 'User', foreign_key: 'user_id'

  validates :user_id, presence: true
  validates :team_id, presence: true
  validates :role,    presence: true
end