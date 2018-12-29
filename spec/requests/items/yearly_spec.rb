require 'rails_helper'

RSpec.describe 'Items/Yearly', type: :request do
  let(:user) { create(:user) }

  before(:each) { sign_in user }

  describe 'GET index' do
    context 'no params' do
      it 'returns items purchased this year' do
        this_year_item = create(:item, user: user, purchase_date: Date.current - 1.day)
        create(:item, user: user, purchase_date: Date.current - 2.years)
        get yearly_items_path
        json_response = JSON.parse(response.body)
        expect(json_response['items'].count).to eq(1)
        expect(json_response['items'].first['id']).to eq(this_year_item.id)
      end
    end

    context 'year param' do
      it 'returns items purchased within given year' do
        this_year_item = create(:item, user: user, purchase_date: Date.current - 1.day)
        specified_year_item = create(:item, user: user, purchase_date: Date.parse('12/12/2012'))
        get yearly_items_path, params: { year: '2012' }
        json_response = JSON.parse(response.body)
        expect(json_response['items'].count).to eq(1)
        expect(json_response['items'].first['id']).to eq(specified_year_item.id)
      end
    end
  end
end
