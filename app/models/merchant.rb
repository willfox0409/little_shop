class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  
  validates :name, presence: true

  def self.sort_by_descending
    Merchant.order(created_at: :desc)
  end
  
  def self.status_returned
    Merchant.joins(:invoices)
    .where(invoices: {status: "returned"})
  end

  def item_count
    items.count
  end
end

