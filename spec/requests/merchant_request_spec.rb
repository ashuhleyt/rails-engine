require 'rails_helper'

describe "merchants API" do 
  context "GET /api/v1/merchants" do 
    it 'returns a list of merchants' do 
      create_list(:merchant, 3)

      get "/api/v1/merchants"

      expect(response).to be_successful 

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(3)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String) 
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_a(String)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it 'can return a single merchant' do 
      id = create(:merchant).id 

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful 

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(Integer)
      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end

    it 'can get all items for a specific merchant based off id' do 
      merchant1 = create(:merchant)
      item1 = create(:item, merchant_id: merchant1.id)
      item2 = create(:item, merchant_id: merchant1.id)

      get "/api/v1/merchants/#{merchant1.id}/items"

      items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(items[:data].count).to eq(2)
    end
  end
end