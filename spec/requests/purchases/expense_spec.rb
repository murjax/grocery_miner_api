require 'rails_helper'

RSpec.describe 'Purchases/Expense', type: :request do
  let(:user) { create(:user) }

  before(:each) { sign_in user }

  describe 'GET index' do
    context 'no params' do
      it 'returns 5 most expensive purchases purchased in the last 30 days' do
        expensive_purchase_price = 105.65
        expensive_purchase = create(:purchase, user: user, price: expensive_purchase_price, purchase_date: Date.current)
        cheap_purchase_price = 0.05
        cheap_purchase = create(:purchase, user: user, price: cheap_purchase_price, purchase_date: Date.current)
        other_purchase_price = 10.50
        5.times do
          create(:purchase, user: user, price: other_purchase_price, purchase_date: Date.current)
        end
        old_expensive_purchase_price = 205.54
        old_expensive_purchase = create(:purchase, user: user, price: old_expensive_purchase_price, purchase_date: Date.current - 2.months)
        get expense_purchases_path
        json_response = JSON.parse(response.body)
        expect(json_response['purchases'].count).to eq(5)
        expect(json_response['purchases'].first['id']).to eq(expensive_purchase.id)
        expect(json_response['purchases'].map{ |purchase| purchase['id'] }).not_to include(old_expensive_purchase.id)
        expect(json_response['purchases'].map{ |purchase| purchase['id'] }).not_to include(cheap_purchase.id)
      end
    end

    context 'range param' do
      it 'returns 5 most expenseive purchases purchased in last day range' do
        expensive_purchase_price = 105.65
        expensive_purchase = create(:purchase, user: user, price: expensive_purchase_price, purchase_date: Date.current)
        cheap_purchase_price = 0.05
        cheap_purchase = create(:purchase, user: user, price: cheap_purchase_price, purchase_date: Date.current)
        other_purchase_price = 10.50
        5.times do
          create(:purchase, user: user, price: other_purchase_price, purchase_date: Date.current)
        end
        old_expensive_purchase_price = 205.54
        old_expensive_purchase = create(:purchase, user: user, price: old_expensive_purchase_price, purchase_date: Date.current - 2.months)
        get expense_purchases_path, params: { range: '90' }
        json_response = JSON.parse(response.body)
        expect(json_response['purchases'].count).to eq(5)
        expect(json_response['purchases'].first['id']).to eq(old_expensive_purchase.id)
        expect(json_response['purchases'][1]['id']).to eq(expensive_purchase.id)
        expect(json_response['purchases'].map{ |purchase| purchase['id'] }).to include(old_expensive_purchase.id)
        expect(json_response['purchases'].map{ |purchase| purchase['id'] }).not_to include(cheap_purchase.id)
      end
    end
  end
end
