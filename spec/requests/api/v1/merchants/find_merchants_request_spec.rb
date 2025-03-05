require "rails_helper"

RSpec.describe "Find Merchants/Items endpoint", type: :request do
  before :each do
    @merchant = Merchant.create!(name: "Prince")
    @merchant2 = Merchant.create!(name: "King")
    @merchant3 = Merchant.create!(name: "King 2")
    @merchant2 = Merchant.create!(name: "something")
  end

  it "returns merchant's with name snippet" do
    get "/api/v1/merchants/find?name", params: {name: "ki"}

    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_an(String)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to eq("King")
  end

  it "returns an empty data hash when no merchants are found" do
    get "/api/v1/merchants/find", params: { name: "hdkiad" }

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true) 

    expect(merchants).to eq( {data: {} } )
  end
end
