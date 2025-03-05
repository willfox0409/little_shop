class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :merchant_id, presence: true

  def self.find_merchants_items(merchant_id)
    where(merchant_id: merchant_id)
  end

  def self.find_items_merchant(item_id)
    merchant_id = where(id: item_id).pluck(:merchant_id)
    Merchant.where(id: merchant_id).first
  end

  def self.full_price(min_price, max_price)
    where(unit_price: min_price..max_price)
  end

  def self.max_price(max_price)
    where("unit_price <= ?", max_price)
  end

  def self.min_price(min_price)
    where("unit_price >= ?", min_price)
  end

  def self.find_by_name(name)
    where("name ILIKE ?", "%#{name}%")
  end
  
  def self.sorted_by_price
    order(:unit_price)
  end

  def merchant_exists?(merchant_id)
    merchant_id_exists = Merchant.where(id: merchant_id)
    if merchant_id_exists.empty? 
      return false 
    else
      return true
    end
  end
end
