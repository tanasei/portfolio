class Public::ItemsController < ApplicationController
  def index
    @items = Item.all.page(params[:page]).per(18)
    @genres = Genre.all
  end

  def show
    @genres = Genre.all
    @item = Item.find(params[:id])
    @image = @item.image
    @cart_items =CartItem.new
  end
end
