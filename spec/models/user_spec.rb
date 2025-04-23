require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  # validações do nome
  it { should validate_presence_of(:name) }

  # validações do Devise/email
  it { should validate_presence_of(:email) }
  it { should allow_value("foo@bar.com").for(:email) }
  it { should_not allow_value("invalid").for(:email) }

  # validação de senha do Devise
  it { should validate_length_of(:password).is_at_least(6) }

  describe 'Devise encrypts password' do
    it 'generates an encrypted_password when setting a password' do
      user = build(:user, password: 'secret123', password_confirmation: 'secret123')

      # encrypted_password should be present and follow bcrypt format
      expect(user.encrypted_password).to be_present
      expect(user.encrypted_password).to match(/\A\$2[aby]\$.{56}\z/)
    end
  end
end
