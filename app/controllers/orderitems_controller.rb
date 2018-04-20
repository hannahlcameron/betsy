class OrderitemsController < ApplicationController
  before_action :find_order_item, only: [:update, :destroy]

  # def index
  # end
  # not sure we need this one

  # def new
  #   @orderitem = OrderItem.new
  # end

  def create
    @orderitem = OrderItem.new(order_item_params)

    if @orderitem.save
      flash[:success] = "Item added successfully!"
      redirect_to products_path
    else
      flash.now[:failure] = "Oops! Something went wrong and we couldn't add this item."
      render "products/show", status: :bad_request
    end
  end

  # def edit
  #   puts "ran inside of edit"
  # end

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

  # def show; end
  # # do we even need this?

  def destroy
    @orderitem.destroy

    redirect_to "order/show"
  end

  private

  def order_item_params
    params.require(:orderitem).permit(:order_id, :product_id, :quantity)
  end

  def find_order_item
    @orderitem = OrderItem.find_by(id: params[:id])
    head :not_found unless @orderitem
  end

end
