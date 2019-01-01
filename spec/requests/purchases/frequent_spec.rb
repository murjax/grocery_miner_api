require 'rails_helper'

RSpec.describe 'Purchases/Frequent', type: :request do
  let(:user) { create(:user) }

  before(:each) { sign_in user }

  describe 'GET index' do
    it 'returns purchase names of 5 most frequently purchased purchases in last 30 days' do
      most_frequent_name = 'Apples'
      least_frequent_name = 'Oranges'
      most_frequent_item = create(:item, name: most_frequent_name)
      least_frequent_item = create(:item, name: least_frequent_name)

      chicken = create(:item, name: 'Chicken')
      turkey = create(:item, name: 'Turkey')
      cheese = create(:item, name: 'Cheese')
      milk = create(:item, name: 'Milk')
      orange_juice = create(:item, name: 'Orange Juice')

      8.times do
        create(:purchase, user: user, item: orange_juice, purchase_date: 2.months.ago)
      end

      6.times do
        create(:purchase, user: user, item: most_frequent_item)
      end

      5.times do
        create(:purchase, user: user, item: chicken)
      end

      4.times do
        create(:purchase, user: user, item: turkey)
      end

      3.times do
        create(:purchase, user: user, item: cheese)
      end

      2.times do
        create(:purchase, user: user, item: milk)
      end

      create(:purchase, user: user, item: least_frequent_item)

      frequent_names = [most_frequent_name, 'Chicken', 'Turkey', 'Cheese', 'Milk']

      get frequent_purchases_path
      json_response = JSON.parse(response.body)

      expect(json_response['names']).to eq(frequent_names)
    end
  end
end
