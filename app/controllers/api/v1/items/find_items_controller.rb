class Api::V1::Items::FindItemsController < ApplicationController
  def show

    if params[:max_price].to_f < 0 || params[:min_price].to_f < 0
      return render json: ErrorSerializer.new("Price cannot be negative", "400"), status: :bad_request
    elsif (params[:max_price] && params[:name]) || (params[:min_price] && params[:name])
      return render json: ErrorSerializer.new("Price and Name can not be queried at the same time", "400"), status: :bad_request
    elsif !params[:name].present? && !params[:min_price].present? && !params[:max_price].present?
      return render json: ErrorSerializer.new("Need parameters to search for an item", "400"), status: :bad_request
    end

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
      return render json: ErrorSerializer.new("Invalid search parameters", status: :bad_request)
    end

    render json: ItemSerializer.format_items(items)
  end
end

