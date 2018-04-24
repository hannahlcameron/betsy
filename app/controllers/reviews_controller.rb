class ReviewsController < ApplicationController

  def create
    @review = Review.new(review_params)

    if @review.save
      flash[:success] = 'Review submitted'
      redirect_to product_path(@review.product_id)
    else
      flash[:failure] = 'Review could not be saved'
      redirect_back(fallback_location: root_path)
    end

  end

  private

  def review_params
    return params.require(:review).permit(:rating, :product_id, :description)
  end
end
