class Api::V1::MerchantsController < ApplicationController
    def index
        merchants = Merchant.all
    end
end