require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  # validações do nome
  it "Verificando presença do nome de usuário" do
    should validate_presence_of(:name)
  end

  # validações do Devise/email
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should allow_value("foo@bar.com").for(:email) }
  it { should_not allow_value("invalid").for(:email) }

  # validação de senha do Devise
  it { should validate_length_of(:password).is_at_least(6) }

  context 'password confirmation' do
    it 'is invalid when password_confirmation does not match' do
      user = build(:user, password: 'secret123', password_confirmation: 'nope')
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  describe 'Devise encrypts password' do
    it 'generates an encrypted_password when setting a password' do
      user = build(:user, password: 'secret123', password_confirmation: 'secret123')

      expect(user.encrypted_password).to be_present
      expect(user.encrypted_password).to match(/\A\$2[aby]\$.{56}\z/)
    end
  end
end
