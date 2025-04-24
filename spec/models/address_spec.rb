require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'associações' do
    it { should belong_to(:user) }
  end

  describe 'validações' do
    it { should validate_presence_of(:zip_code) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
  end
end
