class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def new
  	@order = Order.new
  end

  def confirm
    @cart_items = current_customer.cart_items.all
    @order = Order.new(order_params)
    @order.payment_method = params[:order][:payment_method]
    @order.shipping_cost = 800
    if params[:order][:address_number] == "1"
      @order.post_code = current_customer.post_code
      @order.address = current_customer.address
      @order.destination = current_customer.last_name + current_customer.first_name
    elsif params[:order][:address_number] == "2"
      if Address.find_by(params[:order][:registered])
        @order.post_code = Address.find(params[:order][:registered]).post_code
        @order.destination = Address.find(params[:order][:registered]).destination
        @order.address = Address.find(params[:order][:registered]).address
      else
        render :new
      end
    else params[:order][:address_number] == "3"
      address_new = current_customer.addresses.new
      address_new.post_code = params[:order][:post_code]
      address_new.address = params[:order][:address]
      address_new.destination = params[:order][:destination]
      if address_new.save
        @order.post_code = address_new.post_code
        @order.address = address_new.address
        @order.destination = address_new.destination
      else
        render :new
      end
    end

    #合計金額
    sum = 0
    @cart_items.each do |cart_item|
      sum += (cart_item.amount * cart_item.item.add_tax_price)
    end
    @total_price = sum

    sum = 0
    @cart_items.each do |cart_item|
      sum += (cart_item.item.add_tax_price * cart_item.amount)
    end
    sum += @order.shipping_cost
    @order.bill_maney = sum
  end

  def create
    @order = current_customer.orders.new(order_params)
    @order.shipping_cost = 800
    @order.save
     # カート商品の情報を注文商品に移動
    @cart_items = current_customer.cart_items
    @cart_items.each do |cart_item|
      @order_details = OrderDetail.new
      @order_details.product_id = cart_item.product_id
      @order_details.order_id = @order.id
      @order_details.amount = cart_item.amount
      @order_details.payment = cart_item.item.selling_price*cart_item.amount
      @order_details.production_status = 0
      @order_details.save
    end
    # 注文完了後、カート商品を空にする
    @cart_items.destroy_all
    redirect_to complate_public_orders_path
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
    @order.shipping_cost = 800
    #合計金額
    sum = 0
    @order_details.each do |order_details|
      sum += (order_details.quantity * order_details.item.add_tax_price)
    end
    @total_price = sum
    @total_bill_maney = (sum + @order.shipping_cost)
  end

  def index
    @orders = Order.where(customer_id: current_customer.id).order(created_at: :desc)
  end

  private
  def order_params
    params.require(:order).permit(:customer_id, :total_payment, :shipping_cost, :payment_method, :address, :postal_code, :name, :status)
  end
end
