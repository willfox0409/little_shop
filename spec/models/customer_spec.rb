require "rails_helper"

RSpec.describe Customer, type: :model do
  it {should have_many :invoices}

  describe "" do
    before(:each) do
    end
  end
end

