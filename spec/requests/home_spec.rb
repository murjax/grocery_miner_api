require 'rails_helper'

RSpec.describe 'GET /', type: :request do
  let(:user) { create(:user) }
  context 'user is logged in' do
    it 'is success response' do
      sign_in user
      get root_path
      json_response = JSON.parse(response.body)
      expect(json_response).to eq({ success: true }.stringify_keys)
    end
  end

  context 'user is not logged in' do
    it 'is unauthorized' do
      get root_path
      expect(response.status).to eq 401
    end
  end
end
