require 'rails_helper'

describe "items API" do 
  context "GET /api/v1/items" do 
    it 'sends a list of all items' do 
      create_list(:item, 5)

      get "/api/v1/items"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(5)

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

    it 'can return a single item' do 
      id = create(:item).id 

      get "/api/v1/items/#{id}"

      item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_a(String)
      expect(item[:data]).to have_key(:type)
      expect(item[:data][:type]).to be_a(String)
      expect(item[:data]).to have_key(:attributes)
      expect(item[:data][:attributes]).to be_a(Hash)
      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
    end
  end
  
  context "Post /api/v1/items" do 
    it 'can create a new item' do 
      merchant = create(:merchant)
      item_params = ({
        name: "Chicken Paté",
        description: "Kitten Food",
        unit_price: 42.99,
        merchant_id: merchant.id
        })
        headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)  

      new_item = Item.last

      expect(response).to be_successful 
      expect(new_item.name).to eq(item_params[:name])
      expect(new_item.description).to eq(item_params[:description])
      expect(new_item.unit_price).to eq(item_params[:unit_price])
      expect(new_item.merchant_id).to eq(item_params[:merchant_id])
    end
  end

  context 'Patch /api/v1/items' do 
    it 'can update an item' do 
      id = create(:item).id
      merchant = create(:merchant)
      previous_name = Item.last.name
      item_params = ({
        name: "Liver Mousse",
        description: "Kitten Food",
        unit_price: 42.99,
        merchant_id: merchant.id
        })
      headers = {"CONTENT_TYPE" => "application/json"}
      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)
        
      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq("Liver Mousse") 
    end
  end 

  context 'Patch /api/v1/items' do 
    it 'can delete an item' do 
      item = create(:item)
      
      expect(Item.count).to eq(1)
        
      delete "/api/v1/items/#{item.id}"
      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end 

  context 'Get /api/v1/items/item_id/merchant' do 
    it 'lists the merchant for a given item by id' do 
      id = create(:merchant).id
      item = create(:item, merchant_id: id)

      get "/api/v1/items/#{item.id}/merchant"
      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)
      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to be_a(String)
      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end
  end

  context 'api/v1/items/find?name=hArU, happy path' do 
    it 'lists one item when query is incomplete' do 
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)

      item1 = Item.create!(name: "Cat", description: "furry pet", unit_price: 40, merchant_id: merchant2.id)
      item2 = Item.create!(name: "Dog", description: "sometimes furry pet", unit_price: 60, merchant_id: merchant1.id)
      item3 = Item.create!(name: "Fish", description: "Wet Pet", unit_price: 26, merchant_id: merchant1.id)
      item4 = Item.create!(name: "Beta Fish", description: "Mean Pet", unit_price: 69, merchant_id: merchant1.id)
      item5 = Item.create!(name: "Bird", description: "Loud Pet", unit_price: 420, merchant_id: merchant2.id)

      get "/api/v1/items/find?name=fis"
      item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_a(String)
      expect(item[:data]).to have_key(:type)
      expect(item[:data][:type]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  # context 'api/v1/items/find?name=hArU, sad path path' do 
  #   it 'lists one item when query is incomplete' do 
  #     merchant1 = create(:merchant)
  #     merchant2 = create(:merchant)

  #     item1 = Item.create!(name: "Cat", description: "furry pet", unit_price: 40, merchant_id: merchant2.id)
  #     item2 = Item.create!(name: "Dog", description: "sometimes furry pet", unit_price: 60, merchant_id: merchant1.id)
  #     item3 = Item.create!(name: "Fish", description: "Wet Pet", unit_price: 26, merchant_id: merchant1.id)
  #     item4 = Item.create!(name: "Beta Fish", description: "Mean Pet", unit_price: 69, merchant_id: merchant1.id)
  #     item5 = Item.create!(name: "Bird", description: "Loud Pet", unit_price: 420, merchant_id: merchant2.id)

  #     get "/api/v1/items/find?name=fis"
  #     expect(response).to be_successful
  #   end
  # end

  context 'api/v1/items/find?min_price=50' do 
    it 'lists only one item at minimum price of 50' do 
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)

      item1 = Item.create!(name: "Cat", description: "furry pet", unit_price: 40, merchant_id: merchant2.id)
      item2 = Item.create!(name: "Dog", description: "sometimes furry pet", unit_price: 60, merchant_id: merchant1.id)
      item3 = Item.create!(name: "Fish", description: "Wet Pet", unit_price: 26, merchant_id: merchant1.id)
      item4 = Item.create!(name: "Beta Fish", description: "Mean Pet", unit_price: 69, merchant_id: merchant1.id)
      item5 = Item.create!(name: "Bird", description: "Loud Pet", unit_price: 420, merchant_id: merchant2.id)

      get "/api/v1/items/find?min_price=50"
      item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_a(String)
      expect(item[:data]).to have_key(:type)
      expect(item[:data][:type]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)

      ####WORK IN PROGRESS### #get "/api/v1/items/find?name=homie&min_price=50"
    end
  end
end 
      