class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def top
    @orders = Order.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @order = Order.find(params[:id])
		@order_details = @order.order_details
		@shipping_cost = 800
    #合計金額
    sum = 0
    @order_details.each do |order_details|
      sum += (order_details.quantity * order_details.item.add_tax_price)
    end
    @total_price = sum
    @total_payment = (sum + @shipping_cost)
  end

  def update
    @order = Order.find(params[:id])
		if @order.update(order_params)
		  if @order.order_status == "payment_confirmation"
		      order_details = @order.order_details
		      order_details.update(production_status: 1 )
		  end
		  redirect_to admin_order_path(@order)
		else
		   render :show
		end
  end

  private
	def order_params
		  params.require(:order).permit(:customer_id, :postal_code, :address, :name, :shipping_cost, :total_payment, :payment_method, :status)
	end
end
