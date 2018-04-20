require "test_helper"

describe Review do
  describe "validations" do
    before do
      @old_review_count = Review.count
      @review = Review.new()
      @review.product = Product.first
    end

    it "must have a rating" do
      @review.wont_be :valid?
      @review.save
      Review.count.must_equal @old_review_count
    end

    it "must have a rating that's an integer" do
      @review.rating = "a"
      @review.wont_be :valid?
      @review.save
      Review.count.must_equal @old_review_count
    end

    it "must have a rating that is greater than 0" do
      @review.rating = 0
      @review.wont_be :valid?
      @review.save
      Review.count.must_equal @old_review_count
    end

    it "must have a rating that is less than 6" do
      @review.rating = 6
      @review.wont_be :valid?
      @review.save
      Review.count.must_equal @old_review_count
    end

    it "a valid rating can be created" do
      @review.rating = 3
      @review.must_be :valid?
      @review.save
      Review.count.must_equal @old_review_count + 1
    end

  end # validations

  describe "relations" do

    it "connects product and product id" do
      review = Review.new(rating: 3)
      review.product = Product.first

      review.must_be :valid?
      review.save

      review.product_id.must_equal Product.first.id
    end

  end # relations
end
