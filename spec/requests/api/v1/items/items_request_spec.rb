require "rails_helper"

RSpec.describe "Item endpoints", type: :request do
  describe '#index' do
    it 'lists all items in the database' do
      
      merchant = Merchant.create!(name: 'Merchant1')

      item = Item.create!(
        name: "Baseball Bat",
        description: "it swings fast",
        unit_price: 19.99,
        merchant_id: merchant.id
      )

      item2 = Item.create!(
        name: "Chocolate Bunny",
        description: "it tastes okay",
        unit_price: 3.00,
        merchant_id: merchant.id
      )

      item3 = Item.create!(
        name: "Wagon Wheel",
        description: "it rolls funny",
        unit_price: 70.50,
        merchant_id: merchant.id
      )

      item4 = Item.create!(
        name: "Wood Table",
        description: "Pure wood",
        unit_price: 700.00,
        merchant_id: merchant.id
      )

      get "/api/v1/items"

      items = JSON.parse(response.body, symbolize_names: true)

      items[:data].each do |item|
        expect(response).to be_successful
        expect(items[:data].length).to eq(4)
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
  
  describe "#show" do
    it 'can get a single record based upon item id' do
      merchant_id = Merchant.create!(name: "Carlos Danger").id
      id = Item.create!(name: "Basketball Hoop", description: "Regulation Height", 
      unit_price: 225.00, merchant_id: merchant_id).id.to_s

      get "/api/v1/items/#{id}"

      item = JSON.parse(response.body, symbolize_names: true)
      itemData = item[:data]

      expect(response).to be_successful
      expect(itemData).to have_key(:id)
      expect(itemData[:id]).to be_an(String)
      expect(itemData[:attributes]).to have_key(:name)
      # expect(itemData[:attributes][:name]).to be_a(String)
      expect(itemData[:attributes][:name]).to eq('Basketball Hoop')
      expect(itemData[:attributes]).to have_key(:description)
      # expect(itemData[:attributes][:description]).to be_a(String)
      expect(itemData[:attributes][:description]).to eq('Regulation Height')
      expect(itemData[:attributes]).to have_key(:unit_price)
      # expect(itemData[:attributes][:unit_price]).to be_a(Float)
      expect(itemData[:attributes][:unit_price]).to eq(225.00)
      expect(itemData[:attributes]).to have_key(:merchant_id)
      # expect(itemData[:attributes][:merchant_id]).to be_a(Integer)
      expect(itemData[:attributes][:merchant_id]).to eq(merchant_id)
    end
  end
  
  describe "#create" do
    it 'can create an item' do
      merchant = Merchant.create!(name: "Test Merchant")
      item_params = {
        name: "Chair",
        description: "for sitting",
        unit_price: 15.00,
        merchant_id: merchant.id
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to be_successful
      expect(response).to have_http_status(:created)

      new_item = Item.last

      expect(new_item.name).to eq(item_params[:name])
      expect(new_item.description).to eq(item_params[:description])
      expect(new_item.unit_price).to eq(item_params[:unit_price])
      expect(new_item.merchant_id).to eq(item_params[:merchant_id])
    end
  end

  describe "#update" do
    it 'can update the item' do
      merchant = Merchant.create!(name: 'Bart')
      item = Item.create!(name: 'Cattle Prod', description: 'Pokey Stick', unit_price: 25.00, merchant_id: merchant.id)

      id = item.id
      previous_name = item.name

      item_params = { name: 'Moving Rod' }
      headers = { "CONTENT_TYPE" => "application/json" }
      put "/api/v1/items/#{id}", headers: headers, params: JSON.generate({ item: item_params })
      item.reload

      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq('Moving Rod')
      expect(item.unit_price).to eq(25.00)
    end
  end

  describe "#destroy" do
    it 'can delete a select item' do
      merchant = Merchant.create!(name: "Jaben Witherspank")
      item = Item.create!(name: "Glue Stick", description: "Strong Adhevise", unit_price: 4.99, merchant_id: merchant.id)
      item2 = Item.create!(name: "Balloon", description: "Full of Air", unit_price: 1.75, merchant_id: merchant.id)
      # customer = Customer.create(first_name: "Wes", last_name: "Westerson")
      # invoice = Invoice.create(customer_id: customer.id, merchant_id: merchant.id, status: "sent")
      # invoice_item = InvoiceItem.create(item_id: item.id, invoice_id: invoice.id, quantity: 1, unit_price: item.unit_price)

      expect(Item.all.length).to eq(2)

      # invoice_item.destroy

      delete "/api/v1/items/#{item.id}"

      expect(Item.all.length).to eq(1)
      # expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound) Will eventually happen ahead of time with error handling
    end
  end
end

