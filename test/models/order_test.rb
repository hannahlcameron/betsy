require "test_helper"

describe Order do
  describe 'validations' do

    describe 'validations before changing status from pending to paid' do
      it 'is valid with one order item' do
        order = Order.first
        order.order_items.count.must_equal 1
        order.valid?.must_equal true
      end

      it 'is can be associated with multiple order items' do
        order = Order.create!
        OrderItem.create!(quantity: 1, product: Product.last, order: order, status: 'pending')
        OrderItem.create!(quantity: 1, product: Product.first, order: order, status: 'pending')

        order.order_items.count.must_be :>, 1
        OrderItem.last.order_id.must_equal order.id
        item1 = OrderItem.find(OrderItem.last.id - 1)
        item1.order_id.must_equal order.id
      end

      it 'is valid with 0 order items' do
        order = Order.new
        order.order_items.count.must_equal 0
        order.valid?.must_equal true
      end

    end # validations before changing status

  end # validations

  describe 'business logic' do
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
    end # order_total

    describe 'order_status' do

      describe 'determines the status of an order based on the status of its order items' do
        before do
          @order = Order.create
          @order_item_one = OrderItem.create(product_id: Product.first.id, order_id: @order.id, quantity: 1, status: "pending")
          @order_item_two = OrderItem.create(product_id: Product.last.id, order_id: @order.id, quantity: 1, status: "pending")
          @order.assign_attributes(customer_name: "Bob Belcher", customer_email: "burgers_rule@gmail.com", credit_card: "123456789abcdef0", cvv: "789", cc_expiration: "11/18", shipping_address: "345 Main St., Seattle, WA 54321", billing_address: "54321", status: "paid")
          @order.save
          @order.status.must_equal "paid"

          @order_item_one.update(status: "shipped")
          @order.status.must_equal "paid"
          @order_item_two.update(status: "cancelled")

        end

        it "has a paid status until none of the order items have a pending status" do
          @order.reload
          @order.order_status
          @order.status.must_equal "completed"
        end

        it "has a cancelled status only if all order_items are cancelled" do
          @order.reload
          @order.order_status
          @order.status.must_equal "completed"

          @order_item_one.update(status: "cancelled")

          @order.reload

          @order.order_status
          @order.status.must_equal "cancelled"

        end

      end

    end # order_status


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

    
  end # business logic

end # Order
