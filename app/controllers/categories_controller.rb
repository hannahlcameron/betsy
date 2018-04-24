class CategoriesController < ApplicationController
  before_action :fix_category

  def create
    category = Category.new(name: @category_name)

    if category.save
      flash[:success] = 'Added Category'
      redirect_back(fallback_location: merchant_products_path(@logged_merchant.id))
    else
      flash[:failure] = 'Unable to add category'
      flash[:errors] = category.errors.messages
      render :new, controller: :product, status: :bad_request
    end


  end

  private

  def fix_category
    @category_name = Category.fix_category(params[:name])
  end
end
