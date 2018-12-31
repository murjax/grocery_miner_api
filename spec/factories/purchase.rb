FactoryBot.define do
  factory :purchase do
    name { Faker::Food.fruits }
    price { rand(11.2...76.9) }
    purchase_date { Date.current }
    association :user
  end
end
