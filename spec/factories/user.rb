FactoryBot.define do
  factory :user do
    name { "Usuário Teste" }
    email { Faker::Internet.unique.email }
    password { "123456" }
    password_confirmation { "123456" }

    factory :user_with_address do
      after(:build) do |user|
        user.address ||= Address.new(
          zip_code: '12345-678',
          city: 'São Paulo',
          state: 'SP'
        )
      end
    end
  end
end
