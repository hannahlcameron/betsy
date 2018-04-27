require "test_helper"

describe OrderitemsController do

  describe 'create' do
    it 'can add a valid orderitem' do
      oi_data = {
        product_id: Product.first.id,
        order_id: Order.first.id,
        quantity: 1
      }

      old_oi_count = OrderItem.count

      OrderItem.new(oi_data).must_be :valid?

      post orderitems_path, params: {order_item: oi_data}

      must_respond_with :redirect

      OrderItem.count.must_equal old_oi_count + 1

    end

    it "won't create an invalid orderitem" do
      oi_data = {
        product_id: Product.last.id,
        quantity: Product.last.stock + 1
      }

      old_oi_count = OrderItem.count

      OrderItem.new(oi_data).wont_be :valid?

      post orderitems_path, params: {order_item: oi_data}

      must_respond_with :redirect
      OrderItem.count.must_equal old_oi_count
    end

    it 'will update a current order item quantity if adding more items of the same product to the cart' do
      product1 = Product.first
      orderitem_data = {
        product_id: product1.id,
        quantity: 1
      }
      old_oi_count = OrderItem.count

      post orderitems_path, params: { order_item: orderitem_data }
      OrderItem.count.must_equal old_oi_count + 1

      orderitem = OrderItem.last
      post orderitems_path, params: { order_item: orderitem_data }

      orderitem.reload
      orderitem.quantity.must_equal 2

      order = Order.find(orderitem.order_id)
      product_ones = order.products.select { |product| product.id == product1.id }

      product_ones.length.must_equal 1
    end
  end

  describe 'update' do
    it 'updates an existing orderitem with valid data' do
      orderitem = {
        product_id: Product.first.id,
        order_id: Order.first.id,
        quantity: 1
      }
      post orderitems_path, params: {order_item: orderitem}

      test_io = OrderItem.last

      test_io.assign_attributes(quantity: 2)
      test_io.must_be :valid?

      patch orderitem_path(test_io.id), params: { order_item: {quantity: 2} }

      must_redirect_to viewcart_path(session[:cart_id])
      test_io.reload
      test_io.quantity.must_equal 2

    end

    it 'sends does not update a product for invalid data' do
      orderitem = {
        product_id: Product.first.id,
        order_id: Order.first.id,
        quantity: 1
      }
      post orderitems_path, params: {order_item: orderitem}

      test_io = OrderItem.last

      test_io.assign_attributes(quantity: 0)
      test_io.wont_be :valid?

      patch orderitem_path(test_io.id), params: { order_item: {quantity: 0} }

      must_redirect_to viewcart_path(session[:cart_id])
      test_io.reload
      test_io.quantity.must_equal 1
    end

    it 'redirects to root for orderitem that dne' do
      io_id = OrderItem.last.id + 1
      patch orderitem_path(io_id)

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe 'destroy' do
    it 'responds with success if an orderitem is deleted' do
      io_id = OrderItem.first.id
      old_oi_count = OrderItem.count

      delete orderitem_path(io_id)

      must_respond_with :redirect

      OrderItem.count.must_equal old_oi_count - 1
      OrderItem.find_by(id: io_id).must_be_nil
    end

    it 'redirects to root if orderitem dne' do
      io_id = OrderItem.last.id + 1
      old_oi_count = OrderItem.count

      delete orderitem_path(io_id)

      must_redirect_to root_path
      OrderItem.count.must_equal old_oi_count
    end
  end

  describe 'ship' do
    it "allows you to ship an item that exists" do
      order_item = OrderItem.create(order_id: Order.first.id, product_id: Product.first.id, quantity: 1, status: "pending")
      order_item.status.must_equal "pending"

      patch ship_path(order_item)

      OrderItem.last.status.must_equal "shipped"
    end

    it "redirects to root for an item that doesn't exist" do
      order_item_id = OrderItem.last.id + 1
      order_item = OrderItem.find_by(id: order_item_id)
      order_item.must_be :nil?
      patch ship_path(order_item_id)
      must_redirect_to root_path
    end
  end # ship

  describe 'cancel' do
    it "allows you to cancel an item that exists" do
      order_item = OrderItem.create(order_id: Order.first.id, product_id: Product.first.id, quantity: 1, status: "pending")
      order_item.status.must_equal "pending"

      patch cancel_path(order_item.id)

      OrderItem.last.status.must_equal "cancelled"
    end

    it "responds with not found for an item that doesn't exist" do
      order_item_id = OrderItem.last.id + 1
      order_item = OrderItem.find_by(id: order_item_id)
      order_item.must_be :nil?
      patch cancel_path(order_item_id)
      must_redirect_to root_path
    end
  end # cancel

end
