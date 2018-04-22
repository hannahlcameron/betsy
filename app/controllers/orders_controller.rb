class OrdersController < ApplicationController


  def viewcart
    @current_order =  OrderItem.where(order_id: @order)
  end
end
