require 'rails_helper'

RSpec.describe 'Items/Total per month', type: :request do
  let(:user) { create(:user) }

  before(:each) { sign_in user }

  describe 'GET index' do
    context 'no params' do
      it 'returns totals of items purchased this month' do
        name = 'Apples'
        first_price = 12.50
        second_price = 12.75
        create(:item, user: user, name: name, price: first_price)
        create(:item, user: user, name: name, price: second_price)
        create(:item, user: user, name: name, price: second_price, purchase_date: 2.months.ago)
        get total_per_month_items_path
        json_response = JSON.parse(response.body)
        expect(json_response['items'].count).to eq(1)
        expect(json_response['items'].first['name']).to eq(name)
        expect(json_response['items'].first['price']).to eq((first_price + second_price).to_s)
      end
    end

    context 'month and year param' do
      it 'returns totals of items purchased in given month' do
        name = 'Apples'
        first_price = 12.50
        second_price = 12.75
        create(:item, user: user, name: name, price: first_price)
        create(:item, user: user, name: name, price: second_price)
        create(:item, user: user, name: name, price: second_price, purchase_date: Date.parse('12/12/2012'))
        get total_per_month_items_path, params: { month: '12', year: '2012' }
        json_response = JSON.parse(response.body)
        expect(json_response['items'].count).to eq(1)
        expect(json_response['items'].first['name']).to eq(name)
        expect(json_response['items'].first['price']).to eq(second_price.to_s)
      end
    end

    context 'missing month param' do
      it 'returns totals of items purchased this month' do
        name = 'Apples'
        first_price = 12.50
        second_price = 12.75
        create(:item, user: user, name: name, price: first_price)
        create(:item, user: user, name: name, price: second_price)
        create(:item, user: user, name: name, price: second_price, purchase_date: Date.parse('12/12/2012'))
        get total_per_month_items_path, params: { year: '2012' }
        json_response = JSON.parse(response.body)
        expect(json_response['items'].count).to eq(1)
        expect(json_response['items'].first['name']).to eq(name)
        expect(json_response['items'].first['price']).to eq((first_price + second_price).to_s)
      end
    end

    context 'missing year param' do
      it 'returns totals of items purchased this month' do
        name = 'Apples'
        first_price = 12.50
        second_price = 12.75
        create(:item, user: user, name: name, price: first_price)
        create(:item, user: user, name: name, price: second_price)
        create(:item, user: user, name: name, price: second_price, purchase_date: Date.parse('12/12/2012'))
        get total_per_month_items_path, params: { month: '12' }
        json_response = JSON.parse(response.body)
        expect(json_response['items'].count).to eq(1)
        expect(json_response['items'].first['name']).to eq(name)
        expect(json_response['items'].first['price']).to eq((first_price + second_price).to_s)
      end
    end
  end
end
