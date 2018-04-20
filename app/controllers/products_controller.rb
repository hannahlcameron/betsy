class ProductsController < ApplicationController

  before_action :find_product, only: [:show, :edit, :update]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      # do something
    else
      render :new
    end
  end

  def show; end

  def edit
  end

  def update
  end

  def destroy # this will likely be replaced or used 'non-restfully' - can retire an item but not destroy it
  end

  private

  def product_params
    return params.require(:product).permit(:name, :merchant_id, :stock, :price, :description)
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    render_404 unless @product
  end
end
