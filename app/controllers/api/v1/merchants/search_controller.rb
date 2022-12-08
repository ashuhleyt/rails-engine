class Api::V1::Merchants::SearchController < ApplicationController
  def find_all
    merchant_search = Merchant.search_for_all(params[:name])
    render json: MerchantSerializer.new(merchant_search)
  end
end