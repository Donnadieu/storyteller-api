# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Story, type: :model do
  context 'validations' do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:title) }
  end
end
