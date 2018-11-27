FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "dude_#{n}@dude.net" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
