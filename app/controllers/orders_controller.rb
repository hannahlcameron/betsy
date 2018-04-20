class OrdersController < ApplicationController

  def index
  end
  #
  # def show
  # end
  #
  # def new
  # end
  #
  def create
    order = Order.new

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
  # def update
  # end
  #
  # def destroy
  # end

end
