class Story < ApplicationRecord
  validates :description, presence: true
end
