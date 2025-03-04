class Api::V1::Merchants::ItemsController < ApplicationController
  def show
    items_merchant = Item.find_merchants_items(params[:id])

    if items_merchant.present?
      render json: ItemSerializer.format_items(items_merchant)
    else
      render json: { error: 'Merchant not found' }, status: :not_found
    end
  end
end
