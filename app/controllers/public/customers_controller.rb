class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!, except: [:contact]

  def index
    @customers = Customer.all
  end

  def show
    @customer = current_customer
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to public_customers_path
    else
      render :edit
    end
  end

  def withdrawal
    @customer = current_customer
    current_customer.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end

  private
  def customer_params
    params.require(:customer).permit(:name, :name_kana, :last_name, :first_name, :last_name_kana, :first_name_kana, :postal_code, :address, :telephon_number, :email)
  end

  def ensure_correct_customer
    @customer = Customer.find_by(id:params[:id])
  end
end
