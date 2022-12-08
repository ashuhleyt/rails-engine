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

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)
      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to be_a(String)
      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end

    it 'can get all items for a specific merchant based off id' do 
      merchant1 = create(:merchant).id
      create_list(:item, 10, merchant_id: merchant1)

      get "/api/v1/merchants/#{merchant1}/items"

      items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(items[:data].count).to eq(10)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        expect(item).to have_key(:type)
        expect(item[:type]).to be_a(String)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
      end
    end
  end

  context 'happy path' do 
    it 'returns all merchants that match fragment when query is incomplete' do 
      merchant1 = create(:merchant, name: "Hamburglers")
      merchant2 = create(:merchant, name: "Bobs Burgers")
      merchant3 = create(:merchant, name: "Hot Glizzies")
      
      get "/api/v1/merchants/find_all?name=burg"

      merchant = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      merchant[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_a(String)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end
end