class OrderitemsController < ApplicationController
  before_action :find_order_item, only: [:update, :destroy]
  before_action :order_exists?, only: [:create]


  def create
    @orderitem = OrderItem.new(order_item_params)
    @orderitem.order_id = @order.id

    if @orderitem.save
      flash[:success] = "Item added successfully!"
      redirect_to product_path(@orderitem.product_id)
    else
      flash.now[:failure] = "Oops! Something went wrong and we couldn't add this item."
      render "products/show", status: :bad_request
    end
  end

  def update
    @orderitem.assign_attributes(order_item_params)

    if @orderitem.save
      flash[:success] = "Item added successfully!"
      redirect_to products_path
    else
      flash.now[:failure] = "Oops! Something went wrong and we couldn't add this item."
      render "products/show", status: :bad_request
    end
  end

  def destroy
    @orderitem.destroy

    redirect_to "order/show"
  end

  private

  def order_item_params
    params.require(:order_item).permit(:order_id, :product_id, :quantity)
  end

  def find_order_item
    @orderitem = OrderItem.find_by(id: params[:id])
    head :not_found unless @orderitem
  end

  def order_exists?
    unless @order
      @order = Order.create
    end

  end

end
