require "rails_helper"

RSpec.describe "Find Items endpoint", type: :request do
  before :each do
    @merchant = Merchant.create!(name: "Prince")
    
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
  end

  it "returns items matching a name search" do
    get "/api/v1/items/find_all", params: { name: "Widget" }

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(2)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:name]).to include("Widget")

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it "returns items within a max_price filter" do
    get "/api/v1/items/find_all", params: { max_price: 50 }

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(2)

    items[:data].each do |item|
      expect(item[:attributes][:unit_price]).to be <= 50.00
    end
  end

  it "returns items within a min_price filter" do
    get "/api/v1/items/find_all", params: { min_price: 50 }

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(2)

    items[:data].each do |item|
      expect(item[:attributes][:unit_price]).to be >= 50.00
    end
  end

  it "returns items within a min_price and max_price range" do
    get "/api/v1/items/find_all", params: { min_price: 40, max_price: 80 }

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(1)
    expect(items[:data].first[:attributes][:unit_price]).to eq(50.00)
  end
end
