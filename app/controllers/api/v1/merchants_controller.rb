class Api::V1::MerchantsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :validation_error_response

    def index
        merchants = Merchant.sort_by_descending
        if params[:status].present? 
            merchants = Merchant.with_status(params[:status])
        end
        render json: MerchantSerializer.format_merchants(merchants, params[:count])
    end

    def show
        merchant = Merchant.find(params[:id])
        render json: MerchantSerializer.format_single(merchant)
    end

    def create
        if params[:merchant].nil?
            return render json: ErrorSerializer.new("Can't create a merchant without any params", "400"), status: :bad_request
        end
        merchant = Merchant.create!(merchant_params)
        render json: MerchantSerializer.format_single(merchant), status: :created
    end

    def update
        merchant = Merchant.find(params[:id])
        merchant.update!(merchant_params)
        render json: MerchantSerializer.format_single(merchant)
    end

    def destroy
        merchant = Merchant.find(params[:id])
        merchant.destroy
        render json: { message: "Merchant deleted successfully" }, status: :no_content
    end

    private

    def merchant_params
        params.require(:merchant).permit(:name)
    end

    def not_found_response(exception)
        render json: ErrorSerializer.new(exception.message, "404"), status: :not_found
    end

    def validation_error_response(exception)
        render json: ErrorSerializer.new(exception.record.errors.full_messages.to_sentence, "422"), status: :unprocessable_entity
    end
end