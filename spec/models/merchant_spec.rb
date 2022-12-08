require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
  
  describe 'relationships' do
    it { should have_many(:items) }
  end
  
  describe 'class methods' do 
    describe '#search_for_params' do 
      it 'returns merchants where the partial query matches' do 
        merchant1 = create(:merchant, name: "Hamburglers")
        merchant2 = create(:merchant, name: "Bobs Burgers")
        merchant3 = create(:merchant, name: "Hot Glizzies")
        
        expect(Merchant.search_for_params("burg")).to eq([merchant2, merchant1])
      end
    end
  end
end