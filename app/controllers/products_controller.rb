class ProductsController < ApplicationController

  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.where(retired: false)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      flash[:success] = 'Successfully added product'
      redirect_to merchant_products_path
    else
      flash.now[:failure] = 'Product not created'
      render :new, status: :bad_request
    end
  end

  def show; end

  def edit; end

  def update
    @product.assign_attributes(product_params)

    if @product.save
      flash[:succes] = "Successfully updated product #{@product.id}"
      redirect_to merchant_products_path
    else
      flash.now[:failure] = 'Product not updated'
      render :edit, status: :bad_request
    end
  end

  def destroy
    @product.retired = true

    if @product.save
      flash[:success] = 'Product has been retired'
    else
      flash[:failure] = 'Could not retire product'
    end

    redirect_to merchant_products_path
  end

  private

  def product_params
    return params.require(:product).permit(:name, :merchant_id, :stock, :price, :description)
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    head :not_found unless @product
  end
end
