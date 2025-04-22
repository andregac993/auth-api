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

  context 'quando os dados são válidos' do
    it 'cria o usuário e retorna status 201' do
      post '/api/signup', params: valid_attributes, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['user']['email']).to eq('joao@example.com')
      expect(json['user']['name']).to eq('João Silva')
      expect(json['message']).to match(/Conta criada com sucesso/)
    end
  end

  context 'quando os dados são inválidos' do
    it 'retorna 422 e lista de erros' do
      post '/api/signup',
           params: { user: { name: '', email: 'bad', password: 'a', password_confirmation: 'b' } },
           as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to be_an(Array)
      expect(json['errors']).to include(/Name can't be blank/)
      expect(json['errors']).to include(/Email is invalid/)
    end
  end
end
