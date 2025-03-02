require "rails_helper"

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
  end
  it "belongs to a merchant" do
    merchant = Merchant.create!(name: "Store A")
    item = Item.create!(name: "Product 1", unit_price: 10, merchant: merchant)

    expect(item.merchant).to eq(merchant)
  end

  it "has many invoice items" do
    merchant = Merchant.create!(name: "Store A")
    item = Item.create!(name: "Product 1", unit_price: 10, merchant: merchant)
    invoice = Invoice.create!(customer: Customer.create!(first_name: "John", last_name: "Doe"), merchant: merchant, status: "paid")
    invoice_item = InvoiceItem.create!(invoice: invoice, item: item, quantity: 2, unit_price: 10)

    expect(item.invoice_items).to include(invoice_item)
  end

  describe "#find_merchants_items" do
    it "can return can return the items for a merchant" do
      expect()
    end
  end
end








# RSpec.describe Item, type: :model do
#   it {should belong_to :merchant}

#   it {should has_many :invoice_items}

#   describe "" do
#     before(:each) do
#     end
#   end
# end

