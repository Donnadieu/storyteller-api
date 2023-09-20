class Story < ApplicationRecord
  has_many :user_stories
  has_many :users, through: :user_stories

  validates :description, presence: true
end
