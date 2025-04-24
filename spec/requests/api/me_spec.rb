require 'rails_helper'

RSpec.describe 'GET /api/me', type: :request do
  let(:user_email) { 't@t.com' }
  let(:user_password) { '123456' }

  let(:signup_payload) do
    {
      user: {
        name: 'Teste',
        email: user_email,
        password: user_password,
        password_confirmation: user_password,
        address_attributes: {
          zip_code: '12345-678',
          city: 'São Paulo',
          state: 'SP'
        }
      }
    }
  end

  before do
    post '/api/signup', params: signup_payload, as: :json
  end

  let(:token) do
    post '/api/login',
         params: { user: { email: user_email, password: user_password } },
         as: :json
    JSON.parse(response.body)['token']
  end

  let(:headers) do
    {
      'Authorization' => "Bearer #{token}",
      'Content-Type' => 'application/json'
    }
  end

  it 'retorna 200 e os dados do usuário com endereço quando autenticado' do
    get '/api/me', headers: headers

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)

    expect(json['user']).to match({
                                    'id' => be_an(Integer),
                                    'name' => 'Teste',
                                    'email' => user_email,
                                    'address' => {
                                      'zip_code' => '12345-678',
                                      'city' => 'São Paulo',
                                      'state' => 'SP'
                                    }
                                  })
  end

  it 'retorna 401 se o token for inválido' do
    get '/api/me', headers: { 'Authorization' => "Bearer token_invalido" }

    expect(response).to have_http_status(:unauthorized)
    json = JSON.parse(response.body)
    expect(json['error']).to eq('Invalid token')
  end
end
