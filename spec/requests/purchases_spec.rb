require 'rails_helper'

RSpec.describe 'Purchases', type: :request do
  let(:user) { create(:user) }

  before(:each) { sign_in user }

  describe 'GET index' do
    it 'returns user purchases' do
      user_purchase = create(:purchase, user: user)
      create(:purchase)
      get purchases_path
      json_response = JSON.parse(response.body)
      expect(json_response.count).to eq(1)
      expect(json_response['purchases'].first['id']).to eq(user_purchase.id)
      expect(json_response['purchases'].first['purchase_date']).to eq(user_purchase.purchase_date.to_s)
      expect(json_response['purchases'].first['price']).to eq(user_purchase.price.to_s)
    end
  end

  describe 'GET show' do
    context 'purchase belongs to user' do
      let!(:purchase) { create(:purchase, user: user) }
      it 'returns purchase' do
        get purchase_path(purchase)
        json_response = JSON.parse(response.body)
        expect(json_response['purchase']['id']).to eq(purchase.id)
        expect(json_response['purchase']['purchase_date']).to eq(purchase.purchase_date.to_s)
        expect(json_response['purchase']['price']).to eq(purchase.price.to_s)
      end
    end

    context 'purchase does not belong to user' do
      let!(:purchase) { create(:purchase) }
      it 'is not found' do
        expect do
          get purchase_path(purchase)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PUT update' do
    context 'purchase belongs to user' do
      let!(:purchase) { create(:purchase, user: user) }
      it 'updates purchase' do
        name = 'Apples'
        put purchase_path(purchase), params: { purchase: { name: name } }
        expect(purchase.reload.name).to eq(name)
        json_response = JSON.parse(response.body)
        expect(json_response['purchase']['name']).to eq(name)
      end

      context 'invalid attributes' do
        it 'does not update purchase' do
          put purchase_path(purchase), params: { purchase: { name: nil } }
          expect(purchase.name).not_to be_nil
          json_response = JSON.parse(response.body)
          expect(json_response['errors']['name']).to eq("can't be blank")
          expect(response.status).to eq(422)
        end
      end
    end

    context 'purchase does not belong to user' do
      let!(:purchase) { create(:purchase) }
      it 'is not found' do
        name = 'Apples'
        expect do
          put purchase_path(purchase), params: { purchase: { name: name } }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST create' do
    it 'creates purchase' do
      name = 'Apples'
      price = 19.20
      post purchases_path, params: { purchase: { name: name, price: price, purchase_date: Date.current } }
      json_response = JSON.parse(response.body)
      purchase = Purchase.last
      expect(json_response['purchase']['id']).to eq(purchase.id)
      expect(json_response['purchase']['price']).to eq(price.to_s)
      expect(json_response['purchase']['name']).to eq(name)
    end

    context 'invalid attributes' do
      it 'does not create purchase' do
        price = 19.20
        post purchases_path, params: { purchase: { name: nil, price: price, purchase_date: Date.current } }
        json_response = JSON.parse(response.body)
        expect(json_response['errors']['name']).to eq("can't be blank")
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'purchase belongs to user' do
      it 'destroys purchase' do
        purchase = create(:purchase, user: user)
        delete purchase_path(purchase)
        expect { purchase.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response.status).to eq(204)
      end
    end

    context 'purchase does not belong to user' do
      it 'does not destroy purchase' do
        purchase = create(:purchase)
        expect do
          delete purchase_path(purchase)
        end.to raise_error(ActiveRecord::RecordNotFound)
        expect(purchase.reload.destroyed?).to eq(false)
      end
    end
  end
end
