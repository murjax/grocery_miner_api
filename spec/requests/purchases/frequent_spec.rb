require 'rails_helper'

RSpec.describe 'Purchases/Frequent', type: :request do
  let(:user) { create(:user) }

  before(:each) { sign_in user }

  describe 'GET index' do
    it 'returns purchase names of 5 most frequently purchased purchases in last 30 days' do
      most_frequent_name = 'Apples'
      least_frequent_name = 'Oranges'

      8.times do
        create(:purchase, user: user, name: 'Orange Juice', purchase_date: 2.months.ago)
      end

      6.times do
        create(:purchase, user: user, name: most_frequent_name)
      end

      5.times do
        create(:purchase, user: user, name: 'Chicken')
      end

      4.times do
        create(:purchase, user: user, name: 'Turkey')
      end

      3.times do
        create(:purchase, user: user, name: 'Cheese')
      end

      2.times do
        create(:purchase, user: user, name: 'Milk')
      end

      create(:purchase, user: user, name: least_frequent_name)

      frequent_names = [most_frequent_name, 'Chicken', 'Turkey', 'Cheese', 'Milk']

      get frequent_purchases_path
      json_response = JSON.parse(response.body)

      expect(json_response['names']).to eq(frequent_names)
    end
  end
end
