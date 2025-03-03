class Api::V1::Merchants::ItemsController < ApplicationController
  def show
    items_merchant = Item.find_merchants_items(params[:id])
    render json: ItemSerializer.format_items(items_merchant)
  end
end
