require "rails_helper"

RSpec.describe Transaction, type: :model do
  describe "relationships" do
    it { should belong_to(:invoice) }
  end
  it "belongs to an invoice" do
    invoice = Invoice.create!(customer: Customer.create!(first_name: "John", last_name: "Doe"), merchant: Merchant.create!(name: "Store A"), status: "paid")
    transaction = Transaction.create!(invoice: invoice, credit_card_number: "1234", credit_card_expiration_date: "12/25", result: "success")

    expect(transaction.invoice).to eq(invoice)
  end
end








# RSpec.describe Merchant, type: :model do
#   it {should have_many :items}
#   it {should have_many :invoice}

#   describe "" do
#     before(:each) do
#     end
#   end
# end

