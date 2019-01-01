FactoryBot.define do
  factory :item do
    name { Faker::Food.fruits }
    association :user
  end
end
