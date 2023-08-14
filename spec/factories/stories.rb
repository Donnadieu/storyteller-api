FactoryBot.define do
  factory :story do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
  end
end
