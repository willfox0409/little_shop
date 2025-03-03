require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to(:customer) }
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:transactions) }
  end
  it "belongs to a customer" do
    customer = Customer.create!(first_name: "John", last_name: "Doe")
    invoice = Invoice.create!(customer: customer, merchant: Merchant.create!(name: "Store A"), status: "paid")

    expect(invoice.customer).to eq(customer)
  end

  it "belongs to a merchant" do
    merchant = Merchant.create!(name: "Store A")
    invoice = Invoice.create!(customer: Customer.create!(first_name: "John", last_name: "Doe"), merchant: merchant, status: "paid")

    expect(invoice.merchant).to eq(merchant)
  end

  it "has many invoice items" do
    invoice = Invoice.create!(customer: Customer.create!(first_name: "John", last_name: "Doe"), merchant: Merchant.create!(name: "Store A"), status: "paid")
    item = Item.create!(name: "Product 1", unit_price: 10, merchant: Merchant.create!(name: "Store A"))
    invoice_item = InvoiceItem.create!(invoice: invoice, item: item, quantity: 2, unit_price: 10)

    expect(invoice.invoice_items).to include(invoice_item)
  end

  it "has many transactions" do
    invoice = Invoice.create!(customer: Customer.create!(first_name: "John", last_name: "Doe"), merchant: Merchant.create!(name: "Store A"), status: "paid")
    transaction = Transaction.create!(invoice: invoice, credit_card_number: "1234", credit_card_expiration_date: "12/25", result: "success")

    expect(invoice.transactions).to include(transaction)
  end

  describe "::find_merchants_customers" do
    it "can find the cutomers of a given merchant" do
      expect

    end
  end
end














# RSpec.describe Invoice, type: :model do
#   it {should belong_to :merchant}
#   it {should belong_to :customer}

#   it {should have_many :invoice_items}
#   it {should have_many :transactions}

#   describe "" do
#     before(:each) do
#     end
#   end
# end
