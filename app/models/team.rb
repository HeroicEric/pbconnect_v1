class Team < ActiveRecord::Base
  attr_accessible :name

  has_many :team_memberships, :dependent => :destroy
  has_many :members, :through => :team_memberships

  validates :name, presence: true, length: { in: 3..35 }, uniqueness: true
end
