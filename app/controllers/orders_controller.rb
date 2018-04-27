class OrdersController < ApplicationController

  before_action :order_params, only: [:show, :edit, :update]

  def index
    if session[:merchant_id]
      @merchant = Merchant.find(session[:merchant_id])
      if params[:order_status_filter]
        @orders_and_items = @merchant.merchant_order_items(params[:order_status_filter])
      else
        @orders_and_items = @merchant.merchant_order_items("all")
      end
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
    session[:cart_id] = nil
  end

  # I don't think we really get here anymore
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
  def edit; end

  def update
    @order.assign_attributes(customer_params)

    if @order.order_items.count > 0
      if @order.save
        flash[:success] = "Thank you! Your order has been placed."
        @order.update(status: "paid")

        @order.reduce_stock

        redirect_to order_path(@order)
      else
        flash[:failure] = "The customer information was incomplete."
        render :edit, status: :bad_request
      end
    else
      flash[:failure] = "There are no items to check out"
      redirect_back(fallback_location: root_path)
    end
  end

  def viewcart
    @order = Order.find_by(id: session[:cart_id])
    unless @order
      flash[:error] = 'You do not have any items in your cart'
      redirect_back(fallback_location: root_path)
      return
    end
  end

  private
  def order_params
    @order = Order.find_by(id: session[:cart_id])
    unless @order
      redirect_to root_path
      flash[:failure] = 'Order not found'
    end
  end

  def customer_params
    return params.require(:order).permit(:customer_name, :customer_email, :credit_card, :cvv, :cc_expiration, :shipping_address, :billing_address)
  end

end
