require "test_helper"
require 'pry'

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

  describe "business logic" do

    describe "#merchant_order_items" do

      before do
        @merchant = Merchant.first
        @result = @merchant.merchant_order_items
      end

      it "must return a hash" do
        @result.must_be_kind_of Hash
      end

      it "must have keys corresponding to order id" do
        orders = @merchant.orders
        orders_ids = orders.map { |order| order.id }
        @result.keys.must_equal orders_ids
      end

      it "must have values of type order_item only for products that belong to the merchant" do
        merchant = merchants(:merchant_one)
        orders_and_items = {}
        orders = merchant.orders
        keys = orders.map { |order| order.id }
        products = merchant.products
        order_items = []
        merchant.products.each { |product|
          order_items << product.order_items
        }

        result = merchant.merchant_order_items.values
        result.must_equal order_items
      end

      it "must return an empty hash for a merchant with no orders" do
        @merchant = Merchant.create(username: "Barry Allen", email: "b@rryfast.com")
        @result = @merchant.merchant_order_items
        @result.must_be :empty?
      end

    end # merchant_order_items

  end # business logic

end
