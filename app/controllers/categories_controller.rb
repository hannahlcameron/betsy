class CategoriesController < ApplicationController
  before_action :logged_in_merchant

  def create
    category_name = params[:category][:name]
    category = Category.new(name: category_name)

    if category.save
      flash[:success] = 'Added Category'
    else
      flash[:failure] = 'Unable to add category'
    end

    redirect_back(fallback_location: merchant_products_path(@merchant.id))
  end
end
