class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.sort_by_descending
    Merchant.order(created_at: :desc)
  end
  
  def self.status_returned
    Merchant.joins(:invoices)
    .where(invoices: {status: "returned"})
  end

  def self.find_merchant(merchant_param)
    find_by_sql(["SELECT * FROM merchants WHERE name ILIKE ?", "%#{merchant_param}%"]).first
  end

  def item_count
    items.count
  end

  # scope :sort_by_descending, -> { order(created_at: :desc) }
  # scope :status_returned, -> { joins(:invoices).where(invoices: {status: "returned"})}
end

