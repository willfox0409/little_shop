class Api::V1::Merchants::InvoicesController < ApplicationController
  def show 
    invoices = Invoice.find_merchants_invoices(params[:merchant_id], params[:status])

    if invoices.present?
      render json: InvoiceSerializer.format_invoices(invoices)
    else 
      render json: { error: "Customer not found" }, status: :not_found
    end
  end
end
