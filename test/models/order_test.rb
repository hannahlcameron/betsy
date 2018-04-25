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

  describe 'reduce_stock' do
    it 'reduces the stock for all items by expected amount' do
      order = Order.new
      order.valid?
      order.save
      item1 = OrderItem.first
      item1.quantity = 5
      item1.save
      order.order_items << item1
      item2 = OrderItem.last
      item2.quantity = 8
      item2.save
      order.order_items << item2

      order.order_items.length.must_equal 2

      product1 = item1.product
      product1.stock = 12

      product2 = item2.product
      product2.stock = 9

      order.reduce_stock

      order.reload

      product1.reload
      product2.reload

      product1.stock.must_equal 7
      product2.stock.must_equal 1

    end
  end

end # Order
