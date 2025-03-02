class Api::V1::Merchants::InvoicesController < ApplicationController
  def show 
    invoices = Invoice.find_merchants_invoices(params[:merchant_id])
    render json: InvoiceSerializer.format_customers(invoices)
  end
end
