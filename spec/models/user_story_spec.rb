require 'rails_helper'

RSpec.describe UserStory, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:story) }
  end

  context 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:story_id) }
  end

  context 'uniqueness' do
    it 'validates uniqueness of :user_id scoped to :story_id' do
      # Create a valid user_story record with a user and story
      user = FactoryBot.create(:user)
      # User should be valid without any associated stories
      expect(user).to be_valid

      story = FactoryBot.create(:story)
      _user_story = FactoryBot.create(:user_story, user: user, story: story)

      # Build a new user_story with the same user and story
      new_user_story = FactoryBot.build(:user_story, user: user, story: story)

      # Ensure that the new user_story is not valid due to uniqueness validation
      expect(new_user_story).not_to be_valid
      expect(new_user_story.errors[:user_id]).to include('has already been taken')
    end

  end
end
