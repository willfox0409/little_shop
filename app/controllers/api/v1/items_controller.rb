class Api::V1::ItemsController < ApplicationController
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
        render json: ItemSerializer.format_single(item)
    end

    def update
        item = Item.update(params[:id], item_params)
        render json: ItemSerializer.format_single(item)
    end

    def destroy
        Item.delete(params[:id])
        render json: { message: "Item deleted successfully" }, status: :no_content
    end

    private

    def item_params
        params.require(:item).permit(:name)
    end
end
