class Api::V1::Items::MerchantController < ApplicationController
  def show
    merchant_items = Item.find_items_merchant(params[:id])
    render json: MerchantSerializer.format_merchants(merchant_items, false)
  end
end