class Item < ApplicationRecord
  belongs_to :merchant 
  has_many :invoice_items

  def self.find_merchants_items(merchant_id)
    find_by_sql(["SELECT * FROM items WHERE merchant_id = ?", merchant_id])
  end

  def self.find_items_merchant(item_id)
    merchants = find_by_sql(["SELECT merchant_id FROM items WHERE id = ?", item_id]).pluck(:merchant_id)
    Merchant.find_by_sql(["SELECT * FROM merchants WHERE id IN (?)", merchants])
  end

  def self.full_price(min_price, max_price)
    find_by_sql(["SELECT * FROM items WHERE unit_price >= ? AND unit_price <= ?", min_price, max_price])
  end
  
  def self.max_price(max_price)
    find_by_sql(["SELECT * FROM items WHERE unit_price <= ?", max_price])
  end

  def self.min_price(min_price)
    find_by_sql(["SELECT * FROM items WHERE unit_price >= ?", min_price])
  end

  def self.find_by_name(name)
    find_by_sql(["SELECT * FROM items WHERE name ILIKE ?", "%#{name}%"])
  end

  def self.sorted_by_price
    order(:unit_price)
  end
  
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :merchant_id, presence: true
end
