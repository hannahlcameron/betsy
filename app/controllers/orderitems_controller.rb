class OrderitemsController < ApplicationController
  before_action :find_order_item, only: [:edit, :update, :destroy]

  def index

  end

  def new
    @orderitem = OrderItem.new
  end

  def create
    @orderitem = OrderItem.new(order_item_params)

    if @orderitem.save
      flash[:success] = "Item added successfully!"
      redirect_to products_path
    else
      flash.now[:failure] = "Oops! Something went wrong and we couldn't add this item."
      render "products/show", status: :bad_request
  end

  def edit; end

  def update
    @order_item.assign_attributes(order_item_params)

    if @orderitem.save
      flash[:success] = "Item added successfully!"
      redirect_to products_path
    else
      flash.now[:failure] = "Oops! Something went wrong and we couldn't add this item."
      render "products/show", status: :bad_request

  end

  def show; end

  def destroy
  end

  private

  def order_item_params
    params.require(:orderitem).permit(:order_id, :product_id, :quantity)
  end

end
