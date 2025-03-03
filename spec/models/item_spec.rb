require "rails_helper"

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
  end
  
  it "belongs to a merchant" do
    merchant = Merchant.create!(name: "Store A")
    item = Item.create!(name: "Product 1", description: "banana", unit_price: 10, merchant: merchant)

    expect(item.merchant).to eq(merchant)
  end

  it "has many invoice items" do
    merchant = Merchant.create!(name: "Store A")
    item = Item.create!(name: "Product 1", description: "banana", unit_price: 10, merchant: merchant)
    invoice = Invoice.create!(customer: Customer.create!(first_name: "John", last_name: "Doe"), merchant: merchant, status: "paid")
    invoice_item = InvoiceItem.create!(invoice: invoice, item: item, quantity: 2, unit_price: 10)

    expect(item.invoice_items).to include(invoice_item)
  end

  describe 'class methods' do
    before(:each) do
      @merchant = Merchant.create!(name: "Test Merchant")
      @merchant2 = Merchant.create!(name: "Martin")
      @item1 = Item.create!(name: "Test Item 1", unit_price: 50, merchant: @merchant)
      @item2 = Item.create!(name: "Test Item 2", unit_price: 100, merchant: @merchant)
      @item3 = Item.create!(name: "Another Item", unit_price: 200, merchant: @merchant)
      @item4 = Item.create!(name: "Guitar", unit_price: 322, merchant: @merchant2)
    end

    describe '.find_merchants_items' do
      it 'returns all items for a given merchant' do
        expect(Item.find_merchants_items(@merchant.id)).to eq([@item1, @item2, @item3])
      end
    end

    describe '.find_items_merchant' do
      it 'returns the merchant of a given item' do
        expect(Item.find_items_merchant(@item1.id).first).to eq(@merchant)
      end
    end

    describe '.full_price' do
      it 'returns items within a given price range' do
        expect(Item.full_price(50, 150)).to match_array([@item1, @item2])
      end
    end

    describe '.max_price' do
      it 'returns items with a unit price less than or equal to the given max price' do
        expect(Item.max_price(100)).to match_array([@item1, @item2])
      end
    end

    describe '.min_price' do
      it 'returns items with a unit price greater than or equal to the given min price' do
        expect(Item.min_price(100)).to match_array([@item2, @item3, @item4])
      end
    end

    describe '.find_by_name' do
      it 'returns items that match the given name pattern' do
        expect(Item.find_by_name("Test")).to match_array([@item1, @item2])
      end
    end
  end
end

