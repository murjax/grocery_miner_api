require 'rails_helper'

RSpec.describe 'Items', type: :request do
  let(:user) { create(:user) }

  before(:each) { sign_in user }

  describe 'GET index' do
    it 'returns user items' do
      user_item = create(:item, user: user)
      create(:item)
      get items_path
      json_response = JSON.parse(response.body)
      expect(json_response.count).to eq(1)
      expect(json_response.first['id']).to eq(user_item.id)
      expect(json_response.first['purchase_date']).to eq(user_item.purchase_date.to_s)
      expect(json_response.first['price']).to eq(user_item.price.to_s)
    end
  end

  describe 'GET show' do
    context 'item belongs to user' do
      let!(:item) { create(:item, user: user) }
      it 'returns item' do
        get item_path(item)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(item.id)
        expect(json_response['purchase_date']).to eq(item.purchase_date.to_s)
        expect(json_response['price']).to eq(item.price.to_s)
      end
    end

    context 'item does not belong to user' do
      let!(:item) { create(:item) }
      it 'is not found' do
        expect do
          get item_path(item)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PUT update' do
    context 'item belongs to user' do
      let!(:item) { create(:item, user: user) }
      it 'updates item' do
        name = 'Apples'
        put item_path(item), params: { item: { name: name } }
        expect(item.reload.name).to eq(name)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq(name)
      end

      context 'invalid attributes' do
        it 'does not update item' do
          put item_path(item), params: { item: { name: nil } }
          expect(item.name).not_to be_nil
          json_response = JSON.parse(response.body)
          expect(json_response['errors']['name']).to eq("can't be blank")
          expect(response.status).to eq(422)
        end
      end
    end

    context 'item does not belong to user' do
      let!(:item) { create(:item) }
      it 'is not found' do
        name = 'Apples'
        expect do
          put item_path(item), params: { item: { name: name } }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST create' do
    it 'creates item' do
      name = 'Apples'
      price = 19.20
      post items_path, params: { item: { name: name, price: price, purchase_date: Date.current } }
     json_response = JSON.parse(response.body)
      item = Item.last
      expect(json_response['id']).to eq(item.id)
      expect(json_response['price']).to eq(price.to_s)
      expect(json_response['name']).to eq(name)
    end

    context 'invalid attributes' do
      it 'does not create item' do
        price = 19.20
        post items_path, params: { item: { name: nil, price: price, purchase_date: Date.current } }
        json_response = JSON.parse(response.body)
        expect(json_response['errors']['name']).to eq("can't be blank")
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'item belongs to user' do
      it 'destroys item' do
        item = create(:item, user: user)
        delete item_path(item)
        expect { item.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response.status).to eq(204)
      end
    end

    context 'item does not belong to user' do
      it 'does not destroy item' do
        item = create(:item)
        expect do
          delete item_path(item)
        end.to raise_error(ActiveRecord::RecordNotFound)
        expect(item.reload.destroyed?).to eq(false)
      end
    end
  end
end
