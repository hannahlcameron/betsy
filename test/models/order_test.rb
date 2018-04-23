require "test_helper"

describe Order do
  describe 'validations' do

    describe 'validations before changing status from pending to paid' do
      it 'is valid with one order item' do
        order = Order.first
        order.order_items.count.must_equal 1
        order.valid?.must_equal true
      end

      it 'is valid with multiple order items' do
        order = Order.first
        new_order_item = OrderItem.create(quantity: 1, product: Product.last, order: order)
        order.order_items.count.must_be :>, 1
        order.valid?.must_equal true
      end

      it 'is valid with 0 order items' do
        order = Order.new
        order.order_items.count.must_equal 0
        order.valid?.must_equal true
      end

    end # validations before changing status

  end # validations
end # Order
