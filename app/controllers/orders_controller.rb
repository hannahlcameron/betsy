class OrdersController < ApplicationController

  before_action :order_params, only: [:show, :update]

  def index
    @orders = Order.all
  end

  def show; end
  #
  # def new
  # end
  #
  def create
    order = Order.new(status: "pending")

    if order.save
      flash[:success] = "You have opened up a cart!"
      redirect_back(fallback_location: root_path)
    else
      flash[:failure] = "Could not open up a cart."
      redirect_back(fallback_location: root_path)
    end
  end
  #
  # non-restful view action for editing order_item quantities
  # put customer info form here and edit quantities
  # def edit
  # end
  #
  def update
    @order.assign_attributes(customer_params)

    if @order.order_items.count > 0
      @order.assign_attributes(status: "paid")

      if @order.save
        flash[:success] = "Thank you! Your order has been placed."
        redirect_to order_path(@order)
      else
        flash[:failure] = "The customer information was incomplete."
        redirect_to order_path(@order)
      end

    else
      flash[:failure] = "There are no items to check out"
      redirect_back(fallback_location: root_path)
    end

  end

  def viewcart
    @order = Order.find_by(id: params[:id])     
  end
  #
  # def destroy
  # end

  private
  def order_params
    @order = Order.find_by(id: params[:id])
    head :not_found unless @order
  end

  def customer_params
    return params.permit(:customer_name, :customer_email, :credit_card, :CVV, :CC_expiration, :shipping_address, :billing_address)
  end

end
