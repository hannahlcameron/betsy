class OrdersController < ApplicationController

  before_action :order_params, only: [:show, :update, :viewcart]

  def index
    if session[:merchant_id]
      @merchant = Merchant.find(session[:merchant_id])
      @orders_and_items = @merchant.merchant_order_items
    else
      flash[:failure] = "You must log in as a merchant to see your orders."
      # this IS the root path rn so I get a too many redirects error
      # redirect_to root_path
    end
  end

  def show
    if @order.status != "paid"
      flash[:failure] = "Oops! You need to checkout first!"
      redirect_to edit_order_path(@order)
    end
  end


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
  def edit
    @order = Order.find_by(id: params[:id])
  end

  def update
    @order.assign_attributes(customer_params)

    if @order.order_items.count > 0

      if @order.save
        @order.assign_attributes(status: "paid")
        flash[:success] = "Thank you! Your order has been placed."
        redirect_to order_path(@order)
      else
        flash[:failure] = "The customer information was incomplete."
        render :edit
      end

    else
      flash[:failure] = "There are no items to check out"
      redirect_back(fallback_location: root_path)
    end

  end

  def viewcart; end
  #
  # def destroy
  # end

  private
  def order_params
    @order = Order.find_by(id: params[:id])
    head :not_found unless @order
  end

  def customer_params
    return params.permit(:customer_name, :customer_email, :credit_card, :cvv, :cc_expiration, :shipping_address, :billing_address)
  end

end
