require 'rails_helper'

RSpec.describe 'Purchases/Yearly', type: :request do
  let(:user) { create(:user) }

  before(:each) { sign_in user }

  describe 'GET index' do
    context 'no params' do
      it 'returns purchases purchased this year' do
        this_year_purchase = create(:purchase, user: user, purchase_date: Date.current)
        create(:purchase, user: user, purchase_date: Date.current - 2.years)
        get yearly_purchases_path
        json_response = JSON.parse(response.body)
        expect(json_response['purchases'].count).to eq(1)
        expect(json_response['purchases'].first['id']).to eq(this_year_purchase.id)
      end
    end

    context 'year param' do
      it 'returns purchases purchased within given year' do
        this_year_purchase = create(:purchase, user: user, purchase_date: Date.current)
        specified_year_purchase = create(:purchase, user: user, purchase_date: Date.parse('12/12/2012'))
        get yearly_purchases_path, params: { year: '2012' }
        json_response = JSON.parse(response.body)
        expect(json_response['purchases'].count).to eq(1)
        expect(json_response['purchases'].first['id']).to eq(specified_year_purchase.id)
      end
    end
  end
end
