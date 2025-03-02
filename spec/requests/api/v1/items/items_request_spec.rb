require "rails_helper"

RSpec.describe "Find Merchants/Items endpoint", type: :request do
  before :each do
    @merchant = Merchant.create!(name: "Prince")
    @merchant2 = Merchant.create!(name: "King")
    
    @item1 = Item.create!(name: "Widget", 
                          description: "A useful widget",
                          unit_price: 50.00,
                          merchant_id: @merchant.id)

    @item2 = Item.create!(name: "Gadget", 
                          description: "A cool gadget",
                          unit_price: 30.00,
                          merchant_id: @merchant.id)

    @item3 = Item.create!(name: "Super Widget", 
                          description: "An advanced widget",
                          unit_price: 100.00,
                          merchant_id: @merchant.id)

    @item4 = Item.create!(name: "Super Gadget",
                          description: "A gadget",
                          unit_price: 299,
                          merchant_id: @merchant2.id)                          
    
  end

  it "returns merchant's items" do
    get "/api/v1/merchants/#{@merchant.id}/items", params: { name: "Wid" }

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end
end

