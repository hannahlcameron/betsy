require "test_helper"

describe Merchant do
  describe "validations" do

    it "must have a unique username" do
      # arrange
      merchant = Merchant.first
      old_merchant_count = Merchant.count

      new_merchant = Merchant.new(username: merchant.username, email: "address@example.com")

      # assumptions
      new_merchant.wont_be :valid?

      # act
      new_merchant.save

      # assert
      Merchant.count.must_equal old_merchant_count
    end

    it "must have a unique email" do
      # arrange
      merchant = Merchant.first
      old_merchant_count = Merchant.count

      new_merchant = Merchant.new(username: "example_username", email: merchant.email)

      # assumptions
      new_merchant.wont_be :valid?

      # act
      new_merchant.save

      # assert
      Merchant.count.must_equal old_merchant_count
    end

  end # validations

  describe "relations" do

    it "connects product and product_id" do
      merchant = Merchant.first

      product = Product.new(name: "Green Lantern Ring", stock: 1, price: 57.00)

      # act
      product.merchant = merchant
      product.must_be :valid?

      product.save

      merchant.products.must_include product
    end

  end # relations
end
