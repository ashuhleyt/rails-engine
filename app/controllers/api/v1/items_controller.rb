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
    if Item.exists?(params[:id])
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      render json: { error: 'No item found' }, status: 404
    end
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: 201
  end

  def update
    if Item.exists?(params[:id])
      item = Item.find(params[:id])
      if item.update(item_params)
        render json: ItemSerializer.new(item)
      else
        render json: { error: 'Item not updated' }, status: 404
      end
    else
      render json: { error: 'No item found' }, status: 404
    end
  end

  def destroy
    item = Item.find(params[:id]).destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end