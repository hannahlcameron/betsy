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

        result = merchant.merchant_order_items.values
        result.each do |order_items|
          order_items.each do |order_item|
            order_item.product.merchant_id.must_equal merchant.id
          end
        end

      end

      it "must return an empty hash for a merchant with no orders" do
        @merchant = Merchant.create(username: "Barry Allen", email: "b@rryfast.com")
        @result = @merchant.merchant_order_items
        @result.must_be :empty?
      end

    end # merchant_order_items

    describe "#total_revenue_by" do
      before do
        @merchant = Merchant.first
        @order = Order.create(status: "completed")
        product = Product.create(name: "eye mask", merchant_id: @merchant.id, stock: "20", price: 22.50)
        @order_item = OrderItem.create(product_id: product.id, order_id: @order.id, quantity: 1)
      end

      it "returns the total revenue for all of a merchant's orders" do
        merchant_orders = @merchant.orders
        all_orders_total = 0.00
        merchant_orders.each do |order|
          order.order_items.each do |order_item|
            if order_item.product.merchant_id == @merchant.id
              all_orders_total += order_item.subtotal
            end
          end
        end

        result = @merchant.total_revenue_by("all")
        result.must_equal all_orders_total
      end

      it "returns the total revenue for all of a merchant's orders with status paid" do
        merchant_orders = @merchant.orders
        paid_orders_total = 0.00
        merchant_orders.each do |order|
          order.order_items.each do |order_item|
            if order_item.product.merchant_id == @merchant.id && Order.find(order.id).status == "paid"
              paid_orders_total += order_item.subtotal
            end
          end
        end

        result = @merchant.total_revenue_by("paid")
        result.must_equal paid_orders_total

      end

      it "returns the total revenue for all of a merchant's orders with status completed" do
        merchant_orders = @merchant.orders
        completed_orders_total = 0.00
        merchant_orders.each do |order|
          order.order_items.each do |order_item|
            # binding.pry
            if order_item.product.merchant_id == @merchant.id && Order.find(order.id).status == "completed"
              completed_orders_total += order_item.subtotal
            end
          end
        end

        result = @merchant.total_revenue_by("completed")
        result.must_equal completed_orders_total

      end


      it "returns 0.0 for the total revenue of a merchant with zero orders" do
        merchant = Merchant.new
        result = merchant.total_revenue_by("all")
        result.must_equal 0.0
      end

    end # merchant total_revenue_by

    describe "#count_orders_by" do
      before do
        @merchant = Merchant.first
      end

      it "returns the total number of orders for a merchant" do
        num_orders = @merchant.orders.count
        result = @merchant.count_orders_by("all")
        result.must_equal num_orders
      end

      it "returns the total number of pending orders for a merchant" do
        pending_orders = @merchant.orders.select do |order|
          order.status == "pending"
        end
        result = @merchant.count_orders_by("pending")
        result.must_equal pending_orders.count
      end

      it "returns the total number of paid orders for a merchant" do
        paid_orders = @merchant.orders.select do |order|
          order.status == "paid"
        end
        result = @merchant.count_orders_by("paid")
        result.must_equal paid_orders.count
      end

      it "returns the total number of completed orders for a merchant" do
        completed_orders = @merchant.orders.select do |order|
          order.status == "completed"
        end
        result = @merchant.count_orders_by("completed")
        result.must_equal completed_orders.count
      end

      it "returns the total number of cancelled orders for a merchant" do
        cancelled_orders = @merchant.orders.select do |order|
          order.status == "cancelled"
        end
        result = @merchant.count_orders_by("cancelled")
        result.must_equal cancelled_orders.count
      end

      it "returns 0 for a merchant with zero orders" do
        merchant = Merchant.new
        num_orders = merchant.orders.count
        num_orders.must_equal 0
        result = merchant.count_orders_by("all")
        result.must_equal num_orders
      end

    end # num_orders_by

  end # business logic

end
