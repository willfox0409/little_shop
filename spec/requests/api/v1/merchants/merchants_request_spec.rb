require "rails_helper"

RSpec.describe "Merchants endpoints", type: :request do
  describe "#index" do
    it "lists all merchants in the database" do

      merchant1 = Merchant.create(name: "Billy's Bidets")

      merchant2 = Merchant.create(name: "Maria's Tacos")
      
      merchant3 = Merchant.create(name: "Johnny's Punk-Cuts")

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
  end

  describe "#show" do
    it "can get a single record based on a merchant id" do
      merchant1 = Merchant.create(name: "Billy's Bidets")
      
      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body, symbolize_names: true)
      merchantDAta = merchant[:data]

      expect(response).to be_successful
      expect(merchantData).to have_key(:id)
      expect(merchantData[:id]).to be_an(String)
      expect(merchantData[:attributes]).to have_key(:name)
      expect(merchantData[:attributes][:name]).to eq("Billy's Bidets")
    end
  end

  describe "#create" do
    it "can create a merchant" do
      merchant_params  = { name: "O'Houlihans" }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merchant_params)

      created_merchant = Merchant.last

      expect(response).to_be_successful
      expect(response.status).to eq(201)
      expect(created_merchant.name).to eq("O'Houlihans")
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
      merchant = Merchant.create(name: "Shneebley's Insurance Co.")
    end
  end
end
