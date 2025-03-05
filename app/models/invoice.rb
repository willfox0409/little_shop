class Invoice < ApplicationRecord
  belongs_to :merchant
  belongs_to :customer

  has_many :invoice_items
  has_many :transactions

  def self.find_merchants_invoices(merchant_id, status)
    if status == nil
      self.where(merchant_id: merchant_id)
    else
      self.where(merchant_id: merchant_id, status: status)
    end
  end

  def self.find_merchants_customers(merchant_id)
    customers_id = Invoice.where(merchant_id: merchant_id).pluck(:customer_id)
    Customer.where(id: customers_id)
  end
end
