class Api::V1::Items::FindItemsController < ApplicationController
  def show 
    if params[:max_price] || params[:min_price]
      if params[:max_price] && params[:min_price]
        items = Item.full_price(params[:min_price], params[:max_price])
      elsif params[:max_price]
        items = Item.max_price(params[:max_price])
      elsif params[:min_price]
        items = Item.min_price(params[:min_price])
      end
    elsif params[:name]
      items = Item.find_by_name(params[:name])
    else 
      #TODO Error handler
    end
    render json: ItemSerializer.format_items(items)
  end
end
