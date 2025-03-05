require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "has relationships" do
    it { should belong_to(:customer) }
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:transactions) }
  end
  
  it "belongs to a customer" do
    customer = Customer.create!(first_name: "John", last_name: "Doe")
    invoice = Invoice.create!(customer: customer, merchant: Merchant.create!(name: "Store A"), status: "returned")

    expect(invoice.customer).to eq(customer)
  end

  it "belongs to a merchant" do
    merchant = Merchant.create!(name: "Store A")
    invoice = Invoice.create!(customer: Customer.create!(first_name: "John", last_name: "Doe"), merchant: merchant, status: "returned")

    expect(invoice.merchant).to eq(merchant)
  end

  it "has many invoice items" do
    invoice = Invoice.create!(customer: Customer.create!(first_name: "John", last_name: "Doe"), merchant: Merchant.create!(name: "Store A"), status: "returned")
    item = Item.create!(name: "Product 1", description: "product", unit_price: 10, merchant: Merchant.create!(name: "Store A"))
    invoice_item = InvoiceItem.create!(invoice: invoice, item: item, quantity: 2, unit_price: 10)

    expect(invoice.invoice_items).to include(invoice_item)
  end

  it "has many transactions" do
    merchant = Merchant.create!(name: "Store A")
    invoice = Invoice.create!(customer: Customer.create!(first_name: "John", last_name: "Doe"), merchant: merchant , status: "returned")
    transaction = Transaction.create!(invoice: invoice, credit_card_number: "1234", credit_card_expiration_date: "12/25", result: "success")

    expect(invoice.transactions).to include(transaction)
  end

  describe "::find_merchants_invoices" do
    before(:each) do
      @merchant = Merchant.create!(name: "Store A")
      @customer = Customer.create!(first_name: "John", last_name: "Doe")
      @invoice1 = Invoice.create!(customer: @customer, merchant: @merchant, status: "returned") 
      @invoice2 = Invoice.create!(customer: @customer, merchant: @merchant, status: "shipped") 
      @invoice3 = Invoice.create!(customer: @customer, merchant: @merchant, status: "shipped") 
      @other_merchant_invoice = Invoice.create!(customer: @customer, merchant: Merchant.create!(name: "Other Store"), status: "returned")
    end

    it "can find the invoices of a given merchant with no status" do
      expect(Invoice.find_merchants_invoices(@merchant.id, nil)).to contain_exactly(@invoice1, @invoice2, @invoice3)
    end

    it "can find the invoices of a given merchant with status" do
      expect(Invoice.find_merchants_invoices(@merchant.id, "returned")).to contain_exactly(@invoice1)
      expect(Invoice.find_merchants_invoices(@merchant.id, "shipped")).to contain_exactly(@invoice2, @invoice3)
    end

    it "returns an empty array if no invoices match the given merchant and status" do
      expect(Invoice.find_merchants_invoices(@merchant.id, "shipment")).to be_empty
    end
  end

  describe "::find_merchants_customers" do
    before(:each) do
      @merchant = Merchant.create!(name: "Store A")
      @customer1 = Customer.create!(first_name: "John", last_name: "Doe")
      @customer2 = Customer.create!(first_name: "Jane", last_name: "Smith")
      @customer3 = Customer.create!(first_name: "Alice", last_name: "Johnson")
      @invoice1 = Invoice.create!(customer: @customer1, merchant: @merchant, status: "returned") 
      @invoice2 = Invoice.create!(customer: @customer2, merchant: @merchant, status: "shipped") 
      @invoice3 = Invoice.create!(customer: @customer3, merchant: @merchant, status: "shipped") 
      @other_merchant_customer = Invoice.create!(customer: Customer.create!(first_name: "Bob", last_name: "Brown"), merchant: Merchant.create!(name: "Other Store"), status: "returned")
    end

    it "can find the customers of a given merchant" do
      customers = Invoice.find_merchants_customers(@merchant.id)
      expect(customers).to match_array([@customer1, @customer2, @customer3])
    end

    it "returns an empty array if the merchant has no customers" do
      new_merchant = Merchant.create!(name: "New Store")
      expect(Invoice.find_merchants_customers(new_merchant.id)).to be_empty
    end
  end
end
