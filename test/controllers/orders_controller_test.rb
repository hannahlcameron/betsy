require "test_helper"
require 'pry'

describe OrdersController do

  describe "create" do

    it 'adds a valid order' do
      old_order_count = Order.count

      post orders_path

      must_respond_with :redirect
      # must redirect to same path as before

      Order.count.must_equal old_order_count + 1
      Order.last.status.must_equal "pending"
    end

  end # create

  describe "update" do

    it "incorporates customer information and changes status to paid" do
      order = Order.create(status: "pending")

      order_item = OrderItem.create(quantity: 1, product: Product.first, order: order)

      patch order_path(order), params: {
        customer_name: "Barry Allen",
        customer_email: "run@nike.com",
        credit_card: "1123581321345589",
        CVV: 890,
        CC_expiration: "09/20",
        shipping_address: "200 Washington St., Central City, NJ, 23456",
        billing_address: "23456"
      }

      must_redirect_to order_path(order)

      Order.last.status.must_equal "paid"
    end

  end # update
end
