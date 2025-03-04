class Api::V1::Merchants::CustomerController < ApplicationController
  def show 
    customers = Invoice.find_merchants_customers(params[:merchant_id])

    if customers.present?
      render json: CustomerSerializer.format_customers(customers)
    else 
      render json: { error: "Customer not found" }, status: :not_found
    end
  end
end
