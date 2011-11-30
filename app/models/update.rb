class Update < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { in: 3..140 }

  default_scope order: "created_at desc"

  # Get the updates from a User and those that they follow
  #
  # user - an instance of the User Model
  #
  # Example:
  # Update.from_self_and_followed_by(@user)
  #
  # Returns an array
  def self.from_self_and_followed_by(user)
    ids = user.following_type_ids('User') << user.id
    where(user_id: ids)
  end
end
