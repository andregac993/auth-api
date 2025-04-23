FactoryBot.define do
  factory :user do
    name { "Usuário Teste" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "Passw" }
    password_confirmation { "Password123" }
  end
end
