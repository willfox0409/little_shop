require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
  end
  
  it "has many items" do
    merchant = Merchant.create!(name: "Store A")
    item = Item.create!(name: "Product 1", unit_price: 10, merchant: merchant)

    expect(merchant.items).to include(item)
  end

  it "has many invoices" do
    merchant = Merchant.create!(name: "Store A")
    invoice = Invoice.create!(customer: Customer.create!(first_name: "John", last_name: "Doe"), merchant: merchant, status: "paid")

    expect(merchant.invoices).to include(invoice)
  end

  describe "sort_by_descending" do
    it "returns merchants in descending order by created_at" do
      merchant1 = Merchant.create!(name: "Old Merchant Willie", created_at: 2.days.ago)
      merchant2 = Merchant.create!(name: "New Merchant Josie", created_at: 1.day.ago)
  
      sorted_merchants = Merchant.sort_by_descending
  
      expect(sorted_merchants.first).to eq(merchant2)
      expect(sorted_merchants.first.name).to eq("New Merchant Josie")
      expect(sorted_merchants.last).to eq(merchant1)
      expect(sorted_merchants.last.name).to eq("Old Merchant Willie")
    end
  end

  
end


