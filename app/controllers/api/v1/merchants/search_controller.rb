class Api::V1::Merchants::SearchController < ApplicationController
  def index
    merchant_search = Merchant.search_for_params(params[:name])
    render json: MerchantSerializer.new(merchant_search)
  end
end