class Api::V1::ItemsController < ApplicationController 
  def index 
    if params[:merchant_id] 
      if Merchant.exists?(params[:merchant_id])
        render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
      else  
        render json: {errors: "no items found"}, status: 404
      end 
    else 
      render json: ItemSerializer.new(Item.all)
    end 
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
    item1 = Item.find(params[:id])
    merchant = Merchant.find_by(id: item_params[:merchant_id])
    item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(item) 
    # if Item.exists?(params[:id])
    #   if item_params.has_key?(:merchant_id) && !item_params.valid?(:merchant_id)
    #     render json: {"errors": "Item doesn't exist"}, status: 404
    #   end
    # else
    # end
    #render json: {error: "item not updated"}, status: 404
  end

  def destroy
    item = Item.find(params[:id]).destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end