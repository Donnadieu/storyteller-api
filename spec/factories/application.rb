FactoryBot.define do
  factory :application, class: 'Doorkeeper::Application' do
    name { Faker::Lorem.word }
    uid { SecureRandom.uuid }
    secret { SecureRandom.uuid }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
  end
end
