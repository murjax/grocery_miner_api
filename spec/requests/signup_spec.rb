require 'rails_helper'

RSpec.describe 'POST /signup', type: :request do
  let(:url) { '/signup' }
  let(:params) do
    {
      user: {
        email: 'user@example.com',
        password: 'password'
      }
    }
  end

  context 'when user is unauthenticated' do
    before { post url, params: params }

    it 'returns 200' do
      expect(response.status).to eq 200
    end

    it 'returns a new user' do
      json_response = JSON.parse(response.body)
      user = User.last
      expect(json_response['id']).to eq(user.id)
      expect(json_response['email']).to eq(user.email)
    end
  end

  context 'when user already exists' do
    before do
      create :user, email: params[:user][:email]
      post url, params: params
    end

    it 'returns bad request status' do
      expect(response.status).to eq 400
    end

    it 'returns validation errors' do
      json_response = JSON.parse(response.body)
      expect(json_response['errors'].first['title']).to eq('Bad Request')
    end
  end
end
