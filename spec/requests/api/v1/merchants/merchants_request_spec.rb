require "rails_helper"

RSpec.describe "Merchants endpoints", type: :request do
  describe "#index" do
    it "lists all merchants in the database" do

      merchant1 = Merchant.create!(name: "Billy's Bidets")

      merchant2 = Merchant.create!(name: "Maria's Tacos")
      
      merchant3 = Merchant.create!(name: "Johnny's Punk-Cuts")

      get "/api/v1/merchants"

      merchants = JSON.parse(response.body, symbolize_names: true)

      merchants[:data].each do |merchant|
        expect(response).to be_successful
        expect(merchants[:data].length).to eq(3)
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it "includes item_count when count=true is passed" do 
      merchant = Merchant.create!(name: "De Niro's cigars")
      10.times { Item.create!(name: "Cigarillos", description: "stogies", unit_price: 7, merchant: merchant) }

      get "/api/v1/merchants?count=true"

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchants[:data][0][:attributes]).to have_key(:item_count) 
      expect(merchants[:data][0][:attributes][:item_count]).to eq(10)
    end

    it "returns only merchants with returned invoices when status=returned is passed" do
      merchant1 = Merchant.create(name: "Billy's Bidets")
      merchant2 = Merchant.create(name: "Maria's Tacos")
      
      customer = Customer.create!(first_name: "Scoobert", last_name: "Doobert")

      invoice1 = Invoice.create!(merchant: merchant1, customer: customer, status: "returned") 
      invoice2 = Invoice.create!(merchant: merchant2, customer: customer, status: "shipped") 
  
      get "/api/v1/merchants?status=returned"
  
      merchants = JSON.parse(response.body, symbolize_names: true)
  
      expect(response).to be_successful
      expect(merchants[:data].length).to eq(1)
      expect(merchants[:data][0][:attributes][:name]).to eq("Billy's Bidets") 
    end
  end

  describe "#show" do
    it "can get a single record based on a merchant id" do 
      merchant1 = Merchant.create(name: "Billy's Bidets")
      
      get "/api/v1/merchants/#{merchant1.id}"

      merchant = JSON.parse(response.body, symbolize_names: true)
      merchant_data = merchant[:data]

      expect(response).to be_successful
      expect(merchant_data).to have_key(:id)
      expect(merchant_data[:id]).to be_an(String)
      expect(merchant_data[:attributes]).to have_key(:name)
      expect(merchant_data[:attributes][:name]).to eq("Billy's Bidets")
    end

    it "returns a 404 error if merchant is not found" do # Sad Path
      get "/api/v1/merchants/999999"

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
      expect(error_response[:errors][0][:message]).to eq("Couldn't find Merchant with 'id'=999999")
    end
  end

  describe "#create" do
    it "can create a merchant" do 
      merchant_params  = { name: "O'Houlihans" }

      headers = {"CONTENT_TYPE" => "application/json"}

      puts "Sending POST request with params: #{JSON.generate(merchant_params)}"

      post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merchant_params)

      created_merchant = Merchant.last

      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(created_merchant.name).to eq("O'Houlihans")
    end

    it "returns a 422 error if merchant name is missing" do # Sad Path
      merchant_params = { "merchant": {} } 
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merchant_params)

      puts "Recieved response: #{response.body}"

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(422) 
      expect(error_response[:errors]).to be_an(Array) 
      expect(error_response[:errors][0][:message]).to eq("Name can't be blank") 
    end
  end

  describe "#update" do
    it "can edit the merchant" do
      merchant = Merchant.create(name: "On the Double")

      merchant_params  = { name: "On the Double - UK SNACKS" }

      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/merchants/#{merchant.id}", headers: headers, params: JSON.generate(merchant: merchant_params)
    
      merchant.reload

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(merchant.name).to eq("On the Double - UK SNACKS")
    end
  end

  describe "#destroy" do
    it "can delete a select merchant" do
      merchant1 = Merchant.create(name: "Shneebley's Insurance Co.")
      merchant2 = Merchant.create(name: "Jenny's One Stop Travel Shop")

      expect(Merchant.all.length).to eq(2)

      delete "/api/v1/merchants/#{merchant1.id}"

      expect(Merchant.all.length).to eq(1)
    end
  end
end

