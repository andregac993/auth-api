require 'rails_helper'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

RSpec.describe 'POST /api/signup', type: :request do
  let(:email) { 'joao@example.com' }
  let(:name) { 'João Silva' }
  let(:password) { 'Password123' }

  let(:address_attrs) do
    {
      zip_code: '12345-678',
      city: 'São Paulo',
      state: 'SP'
    }
  end

  let(:valid_attributes) do
    {
      user: {
        name: name,
        email: email,
        password: password,
        password_confirmation: password,
        address_attributes: address_attrs
      }
    }
  end

  before { User.delete_all }

  describe 'quando os dados são válidos' do
    it 'cria o usuário e retorna status 201' do
      post '/api/signup', params: valid_attributes, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['user'].keys).to contain_exactly('id', 'email')
    end

    it 'cria o endereço associado corretamente' do
      expect {
        post '/api/signup', params: valid_attributes, as: :json
      }.to change(Address, :count).by(1)

      user = User.find_by(email: email)
      expect(user).to be_present

      expect(user.address).to have_attributes(
                                zip_code: address_attrs[:zip_code],
                                city: address_attrs[:city],
                                state: address_attrs[:state]
                              )
    end
  end

  describe 'quando já existe um usuário com o mesmo e‑mail' do
    before do
      User.create!(
        name: 'Fulano',
        email: email,
        password: password,
        password_confirmation: password
      )
    end

    it 'retorna 422 e erro de email duplicado' do
      post '/api/signup', params: valid_attributes, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include("Email #{I18n.t('errors.messages.taken')}")
    end
  end

  describe 'validações individuais' do
    it 'falha se nome for ausente' do
      post '/api/signup',
           params: valid_attributes.deep_merge(user: { name: '' }),
           as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include(/Name can't be blank/)
    end

    it 'falha se e‑mail tiver formato inválido' do
      post '/api/signup',
           params: valid_attributes.deep_merge(user: { email: 'invalido' }),
           as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include(/Email is invalid/)
    end

    it 'falha se senha for muito curta' do
      post '/api/signup',
           params: valid_attributes.deep_merge(user: { password: '123', password_confirmation: '123' }),
           as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include(/Password is too short/)
    end

    it 'falha se confirmação não bater com password' do
      post '/api/signup',
           params: valid_attributes.deep_merge(user: { password_confirmation: 'OutraSenha' }),
           as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include(/Password confirmation doesn't match/)
    end
  end

  describe 'payload mal formado' do
    it 'retorna 400 se faltar a raiz `user` nos params' do
      post '/api/signup',
           params: { name: 'x', email: 'x@x.com', password: '123456', password_confirmation: '123456' },
           as: :json

      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body)
      expect(json['error']).to eq("param is missing or the value is empty: user")
    end
  end
end
