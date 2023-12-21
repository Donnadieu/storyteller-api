# frozen_string_literal: true

require 'rails_helper'

describe 'en/translation.yml', type: :feature do
  before do
    I18n.locale = locale
  end

  let!(:locale) { :en }

  it 'returns the expected string for hello' do
    expect(I18n.t('hello')).to eq('Hello customer!')
  end
end
