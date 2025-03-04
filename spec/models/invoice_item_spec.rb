require "rails_helper"

RSpec.describe InvoiceItem, type: :model do
  describe "relationships" do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
  end
  it "belongs to an invoice" do
    invoice = Invoice.create!(customer: Customer.create!(first_name: "John", last_name: "Doe"), merchant: Merchant.create!(name: "Store A"), status: "paid")
    item = Item.create!(name: "Product 1", description: "description", unit_price: 10, merchant: Merchant.create!(name: "Store A"))
    invoice_item = InvoiceItem.create!(invoice: invoice, item: item, quantity: 2, unit_price: 10)

    expect(invoice_item.invoice).to eq(invoice)
  end

  it "belongs to an item" do
    invoice = Invoice.create!(customer: Customer.create!(first_name: "John", last_name: "Doe"), merchant: Merchant.create!(name: "Store A"), status: "paid")
    item = Item.create!(name: "Product 1", description: "description", unit_price: 10, merchant: Merchant.create!(name: "Store A"))
    invoice_item = InvoiceItem.create!(invoice: invoice, item: item, quantity: 2, unit_price: 10)

    expect(invoice_item.item).to eq(item)
  end

end









# RSpec.describe InvoiceItem, type: :model do
#   it {should belong_to :invoice}
#   it {should belong_to :item}

#   describe "" do
#     before(:each) do
#     end
#   end
# end

