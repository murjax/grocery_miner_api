require 'rails_helper'

RSpec.describe 'Items/Expense', type: :request do
  let(:user) { create(:user) }

  before(:each) { sign_in user }

  describe 'GET index' do
    context 'no params' do
      it 'returns 5 most expensive items purchased in the last 30 days' do
        expensive_item_price = 105.65
        expensive_item = create(:item, user: user, price: expensive_item_price, purchase_date: Date.current)
        cheap_item_price = 0.05
        cheap_item = create(:item, user: user, price: cheap_item_price, purchase_date: Date.current)
        other_item_price = 10.50
        5.times do
          create(:item, user: user, price: other_item_price, purchase_date: Date.current)
        end
        old_expensive_item_price = 205.54
        old_expensive_item = create(:item, user: user, price: old_expensive_item_price, purchase_date: Date.current - 2.months)
        get expense_items_path
        json_response = JSON.parse(response.body)
        expect(json_response['items'].count).to eq(5)
        expect(json_response['items'].first['id']).to eq(expensive_item.id)
        expect(json_response['items'].map{ |item| item['id'] }).not_to include(old_expensive_item.id)
        expect(json_response['items'].map{ |item| item['id'] }).not_to include(cheap_item.id)
      end
    end

    context 'range param' do
      it 'returns 5 most expenseive items purchased in last day range' do
        expensive_item_price = 105.65
        expensive_item = create(:item, user: user, price: expensive_item_price, purchase_date: Date.current)
        cheap_item_price = 0.05
        cheap_item = create(:item, user: user, price: cheap_item_price, purchase_date: Date.current)
        other_item_price = 10.50
        5.times do
          create(:item, user: user, price: other_item_price, purchase_date: Date.current)
        end
        old_expensive_item_price = 205.54
        old_expensive_item = create(:item, user: user, price: old_expensive_item_price, purchase_date: Date.current - 2.months)
        get expense_items_path, params: { range: '90' }
        json_response = JSON.parse(response.body)
        expect(json_response['items'].count).to eq(5)
        expect(json_response['items'].first['id']).to eq(old_expensive_item.id)
        expect(json_response['items'][1]['id']).to eq(expensive_item.id)
        expect(json_response['items'].map{ |item| item['id'] }).to include(old_expensive_item.id)
        expect(json_response['items'].map{ |item| item['id'] }).not_to include(cheap_item.id)
      end
    end
  end
end
