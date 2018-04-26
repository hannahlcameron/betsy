class ReviewsController < ApplicationController

  def create
    @review = Review.new(review_params)

    if @review.product.merchant_id == session[:merchant_id]
      flash[:failure] = 'You cannot review your own products!'
      puts "I"
    else
      if @review.save
        flash[:success] = 'Review submitted'
      else
        flash[:failure] = 'Review could not be saved'
        puts 'in else'
      end
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def review_params
    return params.require(:review).permit(:rating, :product_id, :description)
  end
end
