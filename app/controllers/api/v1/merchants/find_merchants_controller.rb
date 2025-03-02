class Api::V1::Merchants::FindMerchantsController < ApplicationController
  def show
    if params[:name]
      merchant = Merchant.find_merchant(params[:name])
    end
    render json: MerchantSerializer.format_single(merchant)
  end
end
