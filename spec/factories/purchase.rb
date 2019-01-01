FactoryBot.define do
  factory :purchase do
    price { rand(11.2...76.9) }
    purchase_date { Date.current }
    association :user
    association :item
  end
end
