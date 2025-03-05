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

   describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
    it { should validate_presence_of(:merchant_id) }
  end

  describe "instance methods" do
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
  end

  describe "class methods" do
    before(:each) do
      @merchant = Merchant.create!(name: "Test Merchant")
      @merchant2 = Merchant.create!(name: "Martin")
      @item1 = Item.create!(name: "Banana", description: "test", unit_price: 50, merchant: @merchant)
      @item2 = Item.create!(name: "Apple", description: "aplle yum", unit_price: 100, merchant: @merchant)
      @item3 = Item.create!(name: "Another Item", description: "another one", unit_price: 200, merchant: @merchant)
      @item4 = Item.create!(name: "Guitar", description: "playable", unit_price: 322, merchant: @merchant2)
    end

    describe '.find_merchants_items' do
      it 'returns all items for a given merchant' do
        expect(Item.find_merchants_items(@merchant.id)).to match_array([@item1, @item2, @item3])
      end

      it 'returns an empty array if the merchant has no items' do
        new_merchant = Merchant.create!(name: "No Items Merchant")
        expect(Item.find_merchants_items(new_merchant.id)).to eq([])
      end
    end

    describe '.find_items_merchant' do
      it 'returns the merchant of a given item' do
        expect(Item.find_items_merchant(@item1.id)).to eq(@merchant)
      end

      it 'returns nil if the item does not exist' do
        expect(Item.find_items_merchant(999999)).to be_nil
      end
    end

    describe '.full_price' do
      it 'returns items within a given price range' do
        expect(Item.full_price(50, 150)).to match_array([@item1, @item2])
      end

      it 'returns an empty array if no items are in the range' do
        expect(Item.full_price(1000, 2000)).to eq([])
      end
    end

    describe '.max_price' do
      it 'returns items with a unit price less than or equal to the given max price' do
        expect(Item.max_price(100)).to match_array([@item1, @item2])
      end

      it 'returns an empty array if no items match the criteria' do
        expect(Item.max_price(10)).to eq([])
      end
    end

    describe '.min_price' do
      it 'returns items with a unit price greater than or equal to the given min price' do
        expect(Item.min_price(100)).to match_array([@item2, @item3, @item4])
      end

      it 'returns an empty array if no items match the criteria' do
        expect(Item.min_price(500)).to eq([])
      end
    end

    describe '.find_by_name' do
      it 'returns items that match the given name pattern' do
        expect(Item.find_by_name("ap")).to match_array([@item2])
      end

      it 'returns an empty array if no items match the given name pattern' do
        expect(Item.find_by_name("Nonexistent")).to eq([])
      end
    end

    describe '.sorted_by_price' do
      it 'returns items sorted by unit price in ascending order' do
        expect(Item.sorted_by_price).to eq([@item1, @item2, @item3, @item4])
      end
    end
  end
end

