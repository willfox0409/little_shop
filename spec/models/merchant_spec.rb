require "rails_helper"

RSpec.describe Merchant, type: :model do
  it {should have_many :items}
  it {should have_many :invoices}

  describe "::sort_by_descending" do
    before(:each) do
    end
  end

  describe "::status_returned" do
    before(:each) do
    end
  end

  describe "#item_count" do
    before(:each) do
    end
  end
end

