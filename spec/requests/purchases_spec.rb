require 'rails_helper'

RSpec.describe 'Purchases', type: :request do
  let(:user) { create(:user) }

  before(:each) { sign_in user }

  describe 'GET index' do
    it 'returns user purchases' do
      user_purchase = create(:purchase, user: user)
      create(:purchase)
      get purchases_path
      expect(json_response[:data].count).to eq(1)
      expect(json_response[:data].first['id']).to eq(user_purchase.id.to_s)
      expect(json_response[:data].first.dig(:attributes, :purchase_date)).to eq(user_purchase.purchase_date.to_s)
      expect(json_response[:data].first.dig(:attributes, :price)).to eq(user_purchase.price.to_s)
    end
  end

  describe 'GET show' do
    context 'purchase belongs to user' do
      let!(:purchase) { create(:purchase, user: user) }
      it 'returns purchase' do
        get purchase_path(purchase)
        expect(json_response.dig(:data, :id)).to eq(purchase.id.to_s)
        expect(json_response.dig(:data, :attributes, :purchase_date)).to eq(purchase.purchase_date.to_s)
        expect(json_response.dig(:data, :attributes, :price)).to eq(purchase.price.to_s)
      end
    end

    context 'purchase does not belong to user' do
      let!(:purchase) { create(:purchase) }
      it 'is not found' do
        get purchase_path(purchase)
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'PUT update' do
    context 'purchase belongs to user' do
      let!(:purchase) { create(:purchase, user: user) }
      it 'updates purchase' do
        price = '5.50'

        headers = { 'CONTENT_TYPE' => 'application/vnd.api+json' }
        put purchase_path(purchase), params: {
          data: {
            type: 'purchases',
            id: purchase.id,
            attributes: {
              price: price
            }
          }
        }.to_json, headers: headers

        expect(purchase.reload.price).to eq(price.to_f)
        expect(json_response.dig(:data, :attributes, :price)).to eq(price.to_f.to_s)
      end

      context 'invalid attributes' do
        it 'does not update purchase' do
          headers = { 'CONTENT_TYPE' => 'application/vnd.api+json' }
          put purchase_path(purchase), params: {
            data: {
              type: 'purchases',
              id: purchase.id,
              attributes: {
                price: nil
              }
            }
          }.to_json, headers: headers

          expect(purchase.reload.price).not_to be_nil
          expect(json_response[:errors].first[:title]).to eq("can't be blank")
          expect(response.status).to eq(422)
        end
      end
    end

    context 'purchase does not belong to user' do
      let!(:purchase) { create(:purchase) }
      it 'is not found' do
        price = '5.50'

        headers = { 'CONTENT_TYPE' => 'application/vnd.api+json' }
        put purchase_path(purchase), params: {
          data: {
            type: 'purchases',
            id: purchase.id,
            attributes: {
              price: price
            }
          }
        }.to_json, headers: headers
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'POST create' do
    it 'creates purchase' do
      price = 19.20
      item = create(:item, user: user)

      headers = { 'CONTENT_TYPE' => 'application/vnd.api+json' }
      post purchases_path, params: {
        data: {
          type: 'purchases',
          attributes: {
            price: price,
            purchase_date: Date.current
          },
          relationships: {
            user: {
              data: {
                type: 'users',
                id: user.id
              }
            },
            item: {
              data: {
                type: 'items',
                id: item.id
              }
            }
          }
        }
      }.to_json, headers: headers

      purchase = Purchase.last

      expect(json_response.dig(:data, :id)).to eq(purchase.id.to_s)
      expect(json_response.dig(:data, :attributes, :price)).to eq(purchase.price.to_s)
    end

    context 'invalid attributes' do
      it 'does not create purchase' do
        price = 19.20
        headers = { 'CONTENT_TYPE' => 'application/vnd.api+json' }
        post purchases_path, params: {
          data: {
            type: 'purchases',
            attributes: {
              price: price,
              purchase_date: Date.current
            },
            relationships: {
              user: {
                data: {
                  type: 'users',
                  id: user.id
                }
              }
            }
          }
        }.to_json, headers: headers
        expect(json_response[:errors].first[:title]).to eq("can't be blank")
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
        delete purchase_path(purchase)
        expect(response.status).to eq(404)
        expect(purchase.reload.destroyed?).to eq(false)
      end
    end
  end
end
