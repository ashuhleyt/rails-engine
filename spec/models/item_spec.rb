require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
  end

  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items)}
    it { should have_many(:invoices).through(:invoice_items)}
  end

  describe 'class methods' do
    describe '#find_item' do
      it 'return the item which has the best match to a given query param' do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)
    
        item1 = Item.create!(name: "Cat", description: "furry pet", unit_price: 40, merchant_id: merchant2.id)
        item2 = Item.create!(name: "Dog", description: "sometimes furry pet", unit_price: 60, merchant_id: merchant1.id)
        item3 = Item.create!(name: "Fish", description: "Wet Pet", unit_price: 26, merchant_id: merchant1.id)
        item4 = Item.create!(name: "Beta Fish", description: "Mean Pet", unit_price: 69, merchant_id: merchant1.id)
        item5 = Item.create!(name: "Bird", description: "Loud Pet", unit_price: 420, merchant_id: merchant2.id)

        expect(Item.find_item("fish")).to eq(item4)
      end
    end
  end
end