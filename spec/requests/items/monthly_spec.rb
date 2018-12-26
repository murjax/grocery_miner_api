require 'rails_helper'

RSpec.describe 'Items/Monthly', type: :request do
  let(:user) { create(:user) }

  before(:each) { sign_in user }

  describe 'GET index' do
    context 'no params' do
      it 'returns items purchased this month' do
        this_month_item = create(:item, user: user, purchase_date: Date.current - 1.day)
        create(:item, user: user, purchase_date: Date.current - 2.months)
        get monthly_items_path
        json_response = JSON.parse(response.body)
        expect(json_response['items'].count).to eq(1)
        expect(json_response['items'].first['id']).to eq(this_month_item.id)
      end
    end

    context 'month and year params' do
      it 'returns items purchased within given month' do
        this_month_item = create(:item, user: user, purchase_date: Date.current - 1.day)
        specified_month_item = create(:item, user: user, purchase_date: Date.parse('12/12/2012'))
        get monthly_items_path, params: { month: '12', year: '2012' }
        json_response = JSON.parse(response.body)
        expect(json_response['items'].count).to eq(1)
        expect(json_response['items'].first['id']).to eq(specified_month_item.id)
      end
    end

    context 'month with no year param' do
      it 'returns items purchased this month' do
        this_month_item = create(:item, user: user, purchase_date: Date.current - 1.day)
        create(:item, user: user, purchase_date: Date.current - 2.months)
        get monthly_items_path, params: { month: '12' }
        json_response = JSON.parse(response.body)
        expect(json_response['items'].count).to eq(1)
        expect(json_response['items'].first['id']).to eq(this_month_item.id)
      end
    end

    context 'year with no month param' do
      it 'returns items purchased this month' do
        this_month_item = create(:item, user: user, purchase_date: Date.current - 1.day)
        create(:item, user: user, purchase_date: Date.current - 2.months)
        get monthly_items_path, params: { year: '2012' }
        json_response = JSON.parse(response.body)
        expect(json_response['items'].count).to eq(1)
        expect(json_response['items'].first['id']).to eq(this_month_item.id)
      end
    end
  end
end
