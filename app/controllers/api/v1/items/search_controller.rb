class Api::V1::Items::SearchController < ApplicationController
  def index
    item_search = Item.find_item(params[:name])
    render json: ItemSerializer.new(item_search)
  end
end     
