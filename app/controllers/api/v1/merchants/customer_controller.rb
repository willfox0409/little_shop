class Api::V1::Merchants::CustomerController < ApplicationController
  def show 
    customers = Invoice.find_merchants_customers(params[:merchant_id])
    render json: CustomerSerializer.format_customers(customers)
  end
end
