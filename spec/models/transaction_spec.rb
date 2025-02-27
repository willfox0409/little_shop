require "rails_helper"

RSpec.describe Merchant, type: :model do
  it {should have_many :items}
  it {should have_many :invoice}

  describe "" do
    before(:each) do
    end
  end
end

