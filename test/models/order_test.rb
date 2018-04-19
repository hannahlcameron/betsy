require "test_helper"

describe Order do
  describe 'validations' do
    it 'is valid with one order item' do
      order_item = OrderItem.first
      order = Order.new
      order.valid?.must_equal false
      order.order_items.push(order_item)

      order.valid?.must_equal true

    end

    it 'is valid with multiple order items' do
      order_item_1 = OrderItem.first
      order_item_2 = OrderItem.last
      order = Order.new
      order.valid?.must_equal false
      order.order_items.push(order_item_1, order_item_2)

      order.valid?.must_equal true
    end

    it 'is not valid with 0 order items' do
      order = Order.new
      order.valid?.must_equal false

      order.errors.messages.must_include :order_items
    end

  end
end
