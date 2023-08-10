FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    image { Faker::Avatar.image }
    email { Faker::Internet.email }
    provider { Faker::Internet.domain_name }
  end
end
