require 'rails_helper'

RSpec.describe 'POST /api/signup', type: :request do
  let(:valid_attributes) do
    {
      user: {
        name:                  'João Silva',
        email:                 'joao@example.com',
        password:              'Password123',
        password_confirmation: 'Password123'
      }
    }
  end

  before { User.delete_all }

  context 'quando os dados são válidos' do
    it 'cria o usuário e retorna status 201' do
      post '/api/signup', params: valid_attributes, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['user']['email']).to eq('joao@example.com')
      expect(json['user']['name']).to  eq('João Silva')
      expect(json['message']).to eq(I18n.t('devise.registrations.signed_up'))
    end
  end

  context 'quando já existe um usuário com o mesmo e‑mail' do
    before { User.create!(name: 'Fulano', email: 'joao@example.com', password: 'Password123', password_confirmation: 'Password123') }

    it 'retorna 422 e erro de email duplicado' do
      post '/api/signup', params: valid_attributes, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include("Email #{I18n.t('errors.messages.taken')}")
    end
  end

  context 'validações individuais' do
    it 'falha se nome for muito curto ou ausente' do
      post '/api/signup',
           params: { user: valid_attributes[:user].merge(name: '') },
           as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include(/Name can't be blank/)
    end

    it 'falha se e‑mail tiver formato inválido' do
      post '/api/signup',
           params: { user: valid_attributes[:user].merge(email: 'invalido') },
           as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include(/Email is invalid/)
    end

    it 'falha se senha for muito curta' do
      post '/api/signup',
           params: { user: valid_attributes[:user].merge(password: '123', password_confirmation: '123') },
           as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include(/Password is too short/)
    end

    it 'falha se confirmation não bate com password' do
      post '/api/signup',
           params: { user: valid_attributes[:user].merge(password_confirmation: 'OutraSenha') },
           as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include(/Password confirmation doesn't match/)
    end
  end

  context 'payload mal formado' do
    it 'retorna 400 se faltar a raiz `user` nos params' do
      post '/api/signup',
           params: { name: 'x', email: 'x@x.com', password: '123456', password_confirmation: '123456' },
           as: :json

      expect(response).to have_http_status(:bad_request) # ou :unprocessable_entity se preferir
    end
  end
end
