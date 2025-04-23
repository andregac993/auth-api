require 'rails_helper'

RSpec.describe 'POST /api/login', type: :request do
  let!(:user) { User.create!(name: 'Teste', email: 't@t.com', password: '123456', password_confirmation: '123456') }

  context 'com credenciais válidas' do
    it 'retorna 200, o usuário e um token JWT' do
      post '/api/login',
           params: { user: { email: user.email, password: '123456' } },
           as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['user']['email']).to eq(user.email)
      expect(json['token']).to be_present
    end
  end

  context 'com credenciais inválidas' do
    it 'retorna 401 e mensagem de erro' do
      post '/api/login',
           params: { user: { email: user.email, password: 'wrong' } },
           as: :json

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body)
      expect(json['error']).to eq(I18n.t('devise.failure.invalid', authentication_keys: 'email'))
    end
  end
end
