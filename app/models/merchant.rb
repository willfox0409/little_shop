class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  
  validates :name, presence: true

  def self.sort_by_descending
    Merchant.order(created_at: :desc)
  end
  
  def self.with_status(status)
    return none unless ["shipped", "packaged", "returned"].include?(status)

    merchant_ids = Invoice.where(status: status).select(:merchant_id)
    where(id: merchant_ids)

  end

  def self.find_merchant(merchant_param)
    Merchant.where("name ILIKE ?", "%#{merchant_param}%").first
  end

  def item_count
    items.count
  end
end
