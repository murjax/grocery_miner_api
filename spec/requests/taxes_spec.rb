require 'rails_helper'

RSpec.describe 'Taxes', type: :request do
  let(:user) { create(:user) }

  before(:each) { sign_in user }

  describe 'GET index' do
    it 'returns user taxes' do
      user_tax = create(:tax, user: user)
      create(:tax)
      get taxes_path
      json_response = JSON.parse(response.body)
      expect(json_response.count).to eq(1)
      expect(json_response.first['id']).to eq(user_tax.id)
      expect(json_response.first['charge_date']).to eq(user_tax.charge_date.to_s)
      expect(json_response.first['amount']).to eq(user_tax.amount.to_s)
    end
  end

  describe 'GET show' do
    context 'tax belongs to user' do
      let!(:tax) { create(:tax, user: user) }
      it 'returns tax' do
        get tax_path(tax)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(tax.id)
        expect(json_response['charge_date']).to eq(tax.charge_date.to_s)
        expect(json_response['amount']).to eq(tax.amount.to_s)
      end
    end

    context 'tax does not belong to user' do
      let!(:tax) { create(:tax) }
      it 'is not found' do
        expect do
          get tax_path(tax)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PUT update' do
    context 'tax belongs to user' do
      let!(:tax) { create(:tax, user: user) }
      it 'updates tax' do
        amount = 12.50
        put tax_path(tax), params: { tax: { amount: amount } }
        expect(tax.reload.amount).to eq(amount)
        json_response = JSON.parse(response.body)
        expect(json_response['amount']).to eq(amount.to_s)
      end

      context 'invalid attributes' do
        it 'does not update tax' do
          put tax_path(tax), params: { tax: { amount: nil } }
          expect(tax.amount).not_to be_nil
          json_response = JSON.parse(response.body)
          expect(json_response['errors']['amount']).to eq("can't be blank")
          expect(response.status).to eq(422)
        end
      end
    end

    context 'tax does not belong to user' do
      let!(:tax) { create(:tax) }
      it 'is not found' do
        amount = 12.50
        expect do
          put tax_path(tax), params: { tax: { amount: amount } }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST create' do
    it 'creates tax' do
      amount = 19.20
      post taxes_path, params: { tax: { amount: amount, user_id: user.id, charge_date: Date.current } }
      json_response = JSON.parse(response.body)
      tax = Tax.last
      expect(json_response['id']).to eq(tax.id)
      expect(json_response['amount']).to eq(amount.to_s)
    end

    context 'invalid attributes' do
      it 'does not create tax' do
        post taxes_path, params: { tax: { amount: nil, user_id: user.id, charge_date: Date.current } }
        json_response = JSON.parse(response.body)
        expect(json_response['errors']['amount']).to eq("can't be blank")
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'tax belongs to user' do
      it 'destroys tax' do
        tax = create(:tax, user: user)
        delete tax_path(tax)
        expect { tax.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response.status).to eq(204)
      end
    end

    context 'tax does not belong to user' do
      it 'does not destroy tax' do
        tax = create(:tax)
        expect do
          delete tax_path(tax)
        end.to raise_error(ActiveRecord::RecordNotFound)
        expect(tax.reload.destroyed?).to eq(false)
      end
    end
  end
end
