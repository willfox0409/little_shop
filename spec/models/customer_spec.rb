require "rails_helper"

RSpec.describe Customer, type: :model do
  describe "relationships" do
    it { should have_many(:invoices) }
  end

  it "has many invoices" do
    customer = Customer.create!(first_name: "John", last_name: "Doe")
    invoice = Invoice.create!(customer: customer, merchant: Merchant.create!(name: "Store A"), status: "paid")
    expect(customer.invoices).to include(invoice)
  end
end