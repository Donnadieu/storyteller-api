# frozen_string_literal: true

class UserStory < ApplicationRecord
  belongs_to :user
  belongs_to :story

  validates :story_id, presence: true
  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: :story_id }

  # TODO: This is a short term data patch while the migration
  #   to use uuids is still in phase 1
  after_create_commit :set_relationship_foreign_keys

  def set_relationship_foreign_keys
    story.update(user_uuid: user.uuid, story_uuid: story.uuid)
  end
end
