FactoryBot.define do
  factory :tax do
    amount { rand(11.2...76.9) }
    charge_date { Date.current }
    association :user
  end
end
