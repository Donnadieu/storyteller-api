class UserStory < ApplicationRecord
  belongs_to :user
  belongs_to :story

  validates :story_id, presence: true
  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: :story_id }
end
