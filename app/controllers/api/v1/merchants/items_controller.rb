class Api::V1::Merchants::ItemsController < ApplicationController
  def show
    merchants_items  = Item.find_merchants_items(params[:id])

    if merchants_items.present?
      render json: ItemSerializer.format_items(merchants_items)
    else
      render json: { error: 'Merchant not found' }, status: :not_found
    end
  end
end
