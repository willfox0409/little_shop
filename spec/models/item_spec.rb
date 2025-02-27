require "rails_helper"

RSpec.describe Item, type: :model do
  it {should belong_to :merchant}

  it {should has_many :invoice_items}

  describe "" do
    before(:each) do
    end
  end
end

