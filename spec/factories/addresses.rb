FactoryBot.define do
  factory :address do
    zip_code { "06358967100" }
    city { "Cidade" }
    state { "Estado" }
    user { nil }
  end
end
