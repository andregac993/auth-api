class User < ApplicationRecord
  # esses são só exemplos — mantenha os módulos que você já usa:
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         # agora o jwt_authenticatable + estratégia de revogação
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  validates :name, presence: true
end
