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
      # make this render new?
      redirect_back(fallback_location: merchant_products_path(@logged_merchant.id))
    end


  end

  private

  def fix_category
      @category_name = params[:name].nil? ?  Category.fix_category(params[:name]) : nil
  end
end
