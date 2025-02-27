class Api::V1::MerchantsController < ApplicationController
    def index
        merchants = Merchant.sort_by_descending
        if params[:status] == "returned"
            merchants = Merchant.status_returned
        end
        render json: MerchantSerializer.format_merchants(merchants)
    end

    def show
        merchant = Merchant.find(params[:id])
        render json: MerchantSerializer.format_single(merchant)
    end

    def create
        merchant = Merchant.create(merchant_params)
        render json: MerchantSerializer.format_single(merchant), status: :created
    end

    def update
        merchant = Merchant.update(params[:id], merchant_params)
        render json: MerchantSerializer.format_single(merchant)
    end

    def destroy
        Merchant.delete(params[:id])
        render json: { message: "Merchant deleted successfully" }, status: :no_content
    end

    private

    def merchant_params
        params.require(:merchant).permit(:name)
    end
end