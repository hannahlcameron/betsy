class CategoriesController < ApplicationController
  def create
    category_name = params[:name]
    category = Category.new(name: category_name)

    if category.save
      flash[:success] = 'Added Category'
    else
      flash[:failure] = 'Unable to add category'
    end

    redirect_back(fallback_location: merchant_products_path(1))
  end
end
