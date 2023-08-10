require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { should have_many(:access_grants) }
    it { should have_many(:access_tokens) }
  end

  context 'validations' do
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:email) }
  end
end
