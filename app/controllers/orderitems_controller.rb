class OrderitemsController < ApplicationController
  before_action :find_order_item, only: [:update, :destroy, :ship, :cancel]
  before_action :order_exists?, only: [:create]


  def create
    @orderitem = OrderItem.new(order_item_params)
    @orderitem.order_id = session[:cart_id]

    if @orderitem.save
      flash[:success] = "Item added successfully!"
      # redirect_back(fallback_location: root_path)
    else
      flash[:failure] = "Oops! Something went wrong and we couldn't add this item."
      # render 'products/show', status: :bad_request
    end
    redirect_to product_path(@orderitem.product_id)
  end

  def update
    @orderitem.assign_attributes(order_item_params)

    if @orderitem.save
      flash[:success] = "Item added successfully!"
    else
      flash[:failure] = "Oops! Something went wrong and we couldn't add this item."
    end
    redirect_to viewcart_path(session[:cart_id])

  end

  def destroy
    @orderitem.destroy

    redirect_to "/order/show"
  end

  def ship
    @orderitem.assign_attributes(status: "shipped")
    if @orderitem.save
      flash[:success] = "You have shipped #{@orderitem.product.name} for order #{@orderitem.order.id}."
    else
      flash[:failure] = "Could not ship item."
    end
    redirect_to orders_path
  end

  def cancel
    @orderitem.assign_attributes(status: "cancelled")
    if @orderitem.save
      flash[:success] = "You have cancelled #{@orderitem.product.name} for order #{@orderitem.order.id}."
    else
      flash[:failure] = "Could not cancel item."
    end
    redirect_to orders_path
  end

  private

  def order_item_params
    params.require(:order_item).permit(:order_id, :product_id, :quantity)
  end

  def find_order_item
    @orderitem = OrderItem.find_by(id: params[:id])
    unless @orderitem
      redirect_to root_path
      flash[:failure] = 'Cart item not found'
    end
  end

  def order_exists?
    unless session[:cart_id]
      @order = Order.create!(status: 'pending')
      session[:cart_id] = @order.id
    end
  end

end
