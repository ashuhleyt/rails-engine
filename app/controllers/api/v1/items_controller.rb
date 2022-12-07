class Api::V1::ItemsController < ApplicationController 
  def index 
    render json: ItemSerializer.new(Item.all)
  end

  def show 
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: 201
  end

  def update 
    merchant = Merchant.find_by(id: item_params[:merchant_id])
    item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(item) #what the fuck am i doing here :) 
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end