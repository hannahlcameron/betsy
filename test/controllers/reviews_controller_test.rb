require "test_helper"

describe ReviewsController do
  describe 'create' do
    let (:old_review_count) { Review.count }

    it 'is successful with valid data' do
      review_data = {
        rating: 5,
        product_id: Product.first.id
      }
      post reviews_path, params: {review: review_data}

      must_redirect_to product_path(Review.last.id)
      Review.count.must_equal old_review_count + 1
    end

    it 'is unsuccessful with invalid data' do
      review_data = {
        rating: 7,
        product_id: Product.first.id
      }

      post reviews_path, params: {review: review_data}

      must_respond_with :redirect
      Review.count.must_equal old_review_count
      Review.last.errors.messages.must_include :rating
    end

  end
end
