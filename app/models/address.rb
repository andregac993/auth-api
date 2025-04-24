class Address < ApplicationRecord
  belongs_to :user

  validates :zip_code, :city, :state, presence: true
end
