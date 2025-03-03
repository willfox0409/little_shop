require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
  end

  describe "validations" do 
    it { should validate_presence_of :name }
  end
  
  it "has many items" do
    merchant = Merchant.create!(name: "Toys R Us")
    item = Item.create!(name: "Jenga", description: "boardgame", unit_price: 10, merchant: merchant)

    expect(merchant.items).to include(item)
  end

  it "has many invoices" do
    merchant = Merchant.create!(name: "Toys R Us")
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

    it "returns an empty ActiveRecord relation when an invalid status is given" do # Edge Case
      merchant = Merchant.create!(name: "Bad Status Merchant")
      customer = Customer.create!(first_name: "Paul", last_name: "Thomas-Anderson")
    
      Invoice.create!(merchant: merchant, customer: customer, status: "shipped")
    
      expect(Merchant.with_status("nonexistent")).to be_empty 
    end
  end

  describe "item_count" do
    it "returns the total count of items for a merchant" do
      merchant = Merchant.create!(name: "Ruby Boozedays")
      5.times { Item.create!(name: "Schlitz", description: "beer", unit_price: 2, merchant: merchant) }

      expect(merchant.item_count).to eq(5)
    end

    it "returns 0 if the merchant has no items and not nil" do # Edge Case
      merchant = Merchant.create!(name: "Abracadabra's Bunnies")
    
      expect(merchant.item_count).to eq(0) 
    end

    it "raises an error when calling item_count on a non-existent merchant ID" do # Sad Path
      expect { Merchant.find(999999).item_count }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end


