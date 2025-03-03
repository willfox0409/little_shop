class Api::V1::ItemsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :validation_error_response

    def index
        items = Item.all
        render json: ItemSerializer.format_items(items)
    end

    def show
        item = Item.find(params[:id])
        render json: ItemSerializer.format_single(item)
    end

    def create
        item = Item.create(item_params)
        render json: ItemSerializer.format_single(item), status: :created
    end
    
    def update
        item = Item.update(params[:id], item_params)
        render json: ItemSerializer.format_single(item)
    end

    def destroy
        Item.destroy(params[:id])
        render json: { message: "Item deleted successfully" }, status: :no_content
    end

    private

    def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

    def not_found_response(exception)
        render json: ErrorSerializer.new(exception.message, "404"), status: :not_found
    end

    def validation_error_response(exception)
        render json: ErrorSerializer.new(exception.record.errors.full_messages.to_sentence, "422"), status: :unprocessable_entity
    end
end
