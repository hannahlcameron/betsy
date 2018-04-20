class OrdersController < ApplicationController

require 'pry'

  def index
  end

  def show
  end
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
  # def edit
  # end
  #
  def update
    order = Order.find(params[:id])
    order.assign_attributes(customer_params)

    if order.order_items.count > 0
      order.assign_attributes(status: "paid")

      if order.save
        flash[:success] = "Thank you! Order has been placed."
        redirect_to order_path(order)
      else
        
      end

    else
      flash[:failure] = "There are no items to check out"
    end

  end
  #
  # def destroy
  # end

  private
  def customer_params
    return params.permit(:customer_name, :customer_email, :credit_card, :CVV, :CC_expiration, :shipping_address, :billing_address)
  end

end
