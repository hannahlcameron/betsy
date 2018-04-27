class ProductsController < ApplicationController

  before_action :find_product, only: [:show, :edit, :update, :destroy]

  # before_action :require_login, except: [:index]

  def index
    @category = Category.find_by(name: params[:category])
    if @category
      @products = Product.by_category(@category.name).where(retired: false).where('stock > 0')
    elsif params[:search]
      @products = Product.find_search(params[:search]).where('stock > 0')
    else
      @products = Product.where(retired: false).where('stock > 0')
    end
  end

  def new
    @product = Product.new
    @category = Category.new
  end

  def create
    @product = Product.new(product_params)
    if @product.photo_url.nil?
      @product.photo_url = "http://www.equistaff.com/Images/noimageavailable.gif"
    end

    if @product.save
      flash[:success] = 'Successfully added product'
      redirect_to merchant_manage_products_path(session[:merchant_id])
    else
      flash.now[:failure] = 'Product not created'
      render :new, status: :bad_request
    end
  end

  def show; end

  def edit; end

  def update
    @product.assign_attributes(product_params)
    if @product.photo_url.nil?
      @product.photo_url = "http://www.equistaff.com/Images/noimageavailable.gif"
    end

    if @product.save
      flash[:success] = "Successfully updated product #{@product.id}"
      redirect_to merchant_manage_products_path(session[:merchant_id])
    else
      flash.now[:failure] = 'Product not updated'
      render :edit, status: :bad_request
    end
  end

  def destroy
    if @product.merchant_id == @logged_merchant.id

      @product.retired = true
      @product.stock_decrement(@product.stock)
      if @product.save
        flash[:success] = 'Product has been retired'
      else
        flash[:failure] = 'Could not retire product'
      end
    else
      flash[:failure] = 'You are not authorized to retire this product'
    end
    redirect_to merchant_manage_products_path(session[:merchant_id])
  end

  private

  def product_params
    return params.require(:product).permit(:name, :merchant_id, :stock, :price, :description, :photo_url, :category_ids => [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    unless @product
      redirect_to root_path
      flash[:failure] = 'Product not found'
    end
  end

end
