require "test_helper"
require 'pry'

describe OrderItem do

  describe "business logic" do

    describe "subtotal" do

      it "returns the price of the product times the quantity of the order item" do
        product = Product.first
        quantity = 2
        order = Order.create
        order_item = OrderItem.new(quantity: quantity, product_id: product.id, order_id: order.id)
        order_item.must_be :valid?
        subtotal = product.price * quantity
        result = order_item.subtotal
        result.must_equal subtotal
      end

    end # subtotal

  end # business logic

end
