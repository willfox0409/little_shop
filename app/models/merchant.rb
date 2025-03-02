class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  
  validates :name, presence: true

  def self.sort_by_descending
    Merchant.order(created_at: :desc)
  end
  
  def self.with_status(status)
    return none unless ["shipped", "packaged", "returned"].include?(status)
    Merchant.joins(:invoices)
    .where(invoices: {status: status})
  end

  def item_count
    items.count
  end
end

