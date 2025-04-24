class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  validates :name, presence: true

  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address
end
