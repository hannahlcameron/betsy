class ProductsController < ApplicationController

  before_action :find_product, only: [:show, :edit, :update, :destroy]

  # before_action :require_login, except: [:index]

  def index
    category = Category.find_by(name: params[:category])
    if category
      @products = Product.by_category(category.name)
    else
      @products = Product.where(retired: false)
    end
  end

  def new
    @product = Product.new
    @category = Category.new
  end

  def new_category
    category_name = params[:name]
    category = Category.new(name: category_name)

    if category.save
      flash[:success] = 'Added Category'
    else
      flash[:failure] = 'Unable to add category'
    end

    redirect_back(fallback_location: merchant_products_path(1))
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
