class UserStory < ApplicationRecord
  belongs_to :user
  belongs_to :story, required: false

  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: :story_id }
end
