class CategoriesController < ApplicationController
  before_action :fix_category

  def create
    category = Category.new(name: @category_name)

    if category.save
      flash[:success] = 'Added Category'
    else
      flash[:failure] = 'Unable to add category'
      flash[:errors] = category.errors.messages
    end

    redirect_back(fallback_location: merchant_products_path(@logged_merchant.id))
  end

  private

  def fix_category
    @category_name = Category.fix_category(params[:name])
  end
end
