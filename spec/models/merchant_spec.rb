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

  describe "::find_merchant" do
    it "can find a merchant that contains the text snippet in their name" do
    end
  end
  # describe "::sort_by_descending" do
  #   before(:each) do
  #   end
  # end

  # describe "::status_returned" do
  #   before(:each) do
  #   end
  # end

  # describe "#item_count" do
  #   before(:each) do
  #   end
  # end
end

