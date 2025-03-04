require "rails_helper"

RSpec.describe "Merchant Invoices API", type: :request do
  before :each do
    @merchant = Merchant.create!(name: "Prince")
    @customer = Customer.create!(first_name: "John", last_name: "Doe")

    @invoice1 = Invoice.create!(merchant: @merchant, customer: @customer, status: "shipped")
    @invoice2 = Invoice.create!(merchant: @merchant, customer: @customer, status: "returned")
    @invoice3 = Invoice.create!(merchant: @merchant, customer: @customer, status: "shipped")
  end

  describe "GET /api/v1/merchants/:merchant_id/invoices" do
    it "returns all invoices for a given merchant when no status is provided" do
      get "/api/v1/merchants/#{@merchant.id}/invoices"

      expect(response).to be_successful
      invoices = JSON.parse(response.body, symbolize_names: true)

      expect(invoices[:data].count).to eq(3)

      invoices[:data].each do |invoice|
        expect(invoice).to have_key(:id)
        expect(invoice[:id]).to be_a(String)

        expect(invoice[:attributes]).to have_key(:status)
        expect(invoice[:attributes][:status]).to be_a(String)

        expect(invoice[:attributes]).to have_key(:merchant_id)
        expect(invoice[:attributes][:merchant_id]).to eq(@merchant.id)

        expect(invoice[:attributes]).to have_key(:customer_id)
        expect(invoice[:attributes][:customer_id]).to eq(@customer.id)
      end
    end

    it "returns only invoices matching the provided status" do
      get "/api/v1/merchants/#{@merchant.id}/invoices", params: { status: "shipped" }

      expect(response).to be_successful
      invoices = JSON.parse(response.body, symbolize_names: true)

      expect(invoices[:data].count).to eq(2) 

      invoices[:data].each do |invoice|
        expect(invoice[:attributes][:status]).to eq("shipped")
      end
    end

    it "returns an empty array when no invoices match the given status" do
      get "/api/v1/merchants/#{@merchant.id}/invoices", params: { status: "packaged" }

      expect(response.status).to eq(404)
    end

    it "returns a 404 error when the merchant does not exist" do
      get "/api/v1/merchants/999999/invoices"

      expect(response).to have_http_status(:not_found)
      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response[:error]).to eq("Customer not found")
    end
  end

end
