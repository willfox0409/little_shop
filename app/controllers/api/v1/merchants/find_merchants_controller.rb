class Api::V1::Merchants::FindMerchantsController < ApplicationController
  def show
    if params[:name]
      merchant = Merchant.find_merchant(params[:name])
    end

     if merchant.present?
        render json: MerchantSerializer.format_single(merchant)
     else
        render json: MerchantSerializer.no_merchant
     end
  end
end
