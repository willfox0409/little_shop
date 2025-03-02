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

  describe "with_status" do
    it "returns merchants with invoices matching the requested status" do
      merchant1 = Merchant.create!(name: "Shipped Merchant")
      merchant2 = Merchant.create!(name: "Returned Merchant")
      merchant3 = Merchant.create!(name: "Packaged Merchant")
  
      customer = Customer.create!(first_name: "Phillip", last_name: "Seymour-Hoffman")
  
      Invoice.create!(merchant: merchant1, customer: customer, status: "shipped")
      Invoice.create!(merchant: merchant2, customer: customer, status: "returned")
      Invoice.create!(merchant: merchant3, customer: customer, status: "packaged")
  
      expect(Merchant.with_status("shipped")).to include(merchant1)
      expect(Merchant.with_status("returned")).to include(merchant2)
      expect(Merchant.with_status("packaged")).to include(merchant3)
    end
  end

  describe "item_count" do
    it "returns the total count of items for a merchant" do
      merchant = Merchant.create!(name: "Ruby Boozedays")
      5.times { Item.create!(name: "Schlitz", merchant: merchant) }

      expect(merchant.item_count).to eq(5)
    end
  end
end


