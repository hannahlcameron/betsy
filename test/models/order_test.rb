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
        order = Order.create!
        OrderItem.create!(quantity: 1, product: Product.last, order: order, status: 'pending')
        OrderItem.create!(quantity: 1, product: Product.first, order: order, status: 'pending')
        order.order_items.count.must_be :>, 1
        order.valid?.must_equal true
      end

      it 'is valid with 0 order items' do
        order = Order.new
        order.order_items.count.must_equal 0
        order.valid?.must_equal true
      end

    end # validations before changing status

    describe 'order_total' do
      before do
        @order = Order.new
        @order.order_items << OrderItem.first
        @order.valid?.must_equal true
        @order.save
      end
      it 'returns the correct total when there is one orderitem' do
        @order.order_items.length.must_equal 1
        total = @order.order_total

        total.must_equal OrderItem.first.product.price

      end
      it 'returns the correct total when there are multiple orderitems' do
        @order.order_items << OrderItem.last

        @order.order_items.length.must_equal 2

        total = @order.order_total

        total.must_equal OrderItem.first.product.price + OrderItem.last.product.price
      end
    end

  end # validations
end # Order
