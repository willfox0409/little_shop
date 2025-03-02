class Invoice < ApplicationRecord
  belongs_to :merchant
  belongs_to :customer

  has_many :invoice_items
  has_many :transactions

  def self.find_merchants_customers(merchant_id)
    customers_id = find_by_sql(["SELECT customer_id FROM invoices WHERE merchant_id = ?", merchant_id]).pluck(:customer_id)
    return [] if customers_id.empty?
    find_by_sql(["SELECT * FROM customers WHERE id IN (?)", customers_id])
  end
end
