class Api::V1::Items::MerchantController < ApplicationController
  def show
    items_merchant = Item.find_items_merchant(params[:id])

    if items_merchant.present?
      render json: MerchantSerializer.format_single(items_merchant)
    else
      render json: { error: 'Merchant not found' }, status: :not_found
    end
  end
end
