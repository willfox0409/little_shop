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

  describe "::find_merchant" do
    before(:each) do
      @merchant1 = Merchant.create!(name: "Cool Gadgets")
      @merchant2 = Merchant.create!(name: "Hot Tech")
      @merchant3 = Merchant.create!(name: "Frozen Goods")
    end

    it "can find a merchant that contains the text snippet in their name" do
      expect(Merchant.find_merchant("Cool")).to eq(@merchant1)
      expect(Merchant.find_merchant("Tech")).to eq(@merchant2)
      expect(Merchant.find_merchant("Goods")).to eq(@merchant3)
    end

    it "is case-insensitive when searching for a merchant" do
      expect(Merchant.find_merchant("cool")).to eq(@merchant1)
      expect(Merchant.find_merchant("tEcH")).to eq(@merchant2)
      expect(Merchant.find_merchant("GOODS")).to eq(@merchant3)
    end

    it "returns nil if no merchant name matches the search term" do
      expect(Merchant.find_merchant("Nonexistent")).to be_nil
    end
  end

  describe "::sort_by_descending" do
    it "returns merchants in descending order by created_at" do
      merchant1 = Merchant.create!(name: "Old Merchant Willie", created_at: 2.days.ago)
      merchant2 = Merchant.create!(name: "New Merchant Josie", created_at: 1.day.ago)

      sorted_merchants = Merchant.sort_by_descending

      expect(sorted_merchants.first).to eq(merchant2)
      expect(sorted_merchants.first.name).to eq("New Merchant Josie")
      expect(sorted_merchants.last).to eq(merchant1)
      expect(sorted_merchants.last.name).to eq("Old Merchant Willie")
    end

    it "returns an empty ActiveRecord relation if no merchants exist" do # Edge Case
      Merchant.destroy_all
      expect(Merchant.sort_by_descending).to be_empty
    end
  end

  describe "::with_status" do
    before(:each) do
      @merchant1 = Merchant.create!(name: "Shipped Merchant")
      @merchant2 = Merchant.create!(name: "Returned Merchant")
      @merchant3 = Merchant.create!(name: "Packaged Merchant")
      @customer = Customer.create!(first_name: "Phillip", last_name: "Seymour-Hoffman")

      Invoice.create!(merchant: @merchant1, customer: @customer, status: "shipped")
      Invoice.create!(merchant: @merchant2, customer: @customer, status: "returned")
      Invoice.create!(merchant: @merchant3, customer: @customer, status: "packaged")
    end

    it "returns merchants with invoices matching the requested status" do
      expect(Merchant.with_status("shipped")).to include(@merchant1)
      expect(Merchant.with_status("returned")).to include(@merchant2)
      expect(Merchant.with_status("packaged")).to include(@merchant3)
    end

    it "returns an empty ActiveRecord relation when an invalid status is given" do # Edge Case
      expect(Merchant.with_status("nonexistent")).to be_empty
    end

    it "returns an empty ActiveRecord relation if no merchants have invoices with the given status" do # Edge Case
      Invoice.destroy_all
      Merchant.destroy_all
      expect(Merchant.with_status("shipped")).to be_empty
    end
  end

  describe "#item_count" do
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
