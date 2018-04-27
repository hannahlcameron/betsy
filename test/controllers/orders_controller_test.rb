require "test_helper"

describe OrdersController do
  describe "logged in merchant" do

    before do
      login(Merchant.first)
      @orders = Merchant.first.orders
    end

    describe "index" do

      it "sends a success response when there are many orders" do
        @orders.count.must_be :>, 0
        get orders_path
        must_respond_with :success
      end

      it "sends a success response when there are no orders" do
        Order.destroy_all
        @orders.count.must_equal 0
        get orders_path
        must_respond_with :success
      end

    end # index
  end # logged in merchant

  describe "show" do

    it "sends success if there is an order and status is paid" do
      orderitem = {product_id: Product.first.id, quantity: Product.first.stock}

      post orderitems_path, params: {order_item: orderitem}

      order = Order.find(session[:cart_id])
      order.update_attributes(
        cc_expiration: '234',
        cvv: '2',
        customer_name: '23',
        customer_email: 'sf',
        credit_card: 'asdf',
        shipping_address: 'asdf',
        billing_address: '234'
      )
      order.status = "paid"
      order.save!
      get order_path(order)
      must_respond_with :success
    end

    it "sends not_found if the order does not exist" do
      order_id = Order.last.id + 1
      get order_path(order_id)
      must_respond_with :not_found
    end

    it "redirects to edit_path if order status != paid" do
      orderitem = {product_id: Product.first.id, quantity: Product.first.stock}

      post orderitems_path, params: {order_item: orderitem}

      order = Order.find(session[:cart_id])
      order.update_attributes(
        cc_expiration: '234',
        cvv: '2',
        customer_name: '23',
        customer_email: 'sf',
        credit_card: 'asdf',
        shipping_address: 'asdf',
        billing_address: '234'
      )
      order.status = "pending"
      order.save!

      get order_path(order)
      must_redirect_to edit_order_path(order.id)

    end

  end # show

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

    it "incorporates complete customer information and changes status to paid" do
      product = Product.first
      orderitem = {product_id: product.id, quantity: product.stock}
      post orderitems_path, params: {order_item: orderitem}

      order_id = Order.last.id

      order_data = {
        customer_name: "Barry Allen",
        customer_email: "run@nike.com",
        credit_card: "1123581321345589",
        cvv: "890",
        cc_expiration: "09/20",
        shipping_address: "200 Washington St., Central City, NJ, 23456",
        billing_address: "23456"
      }
      patch order_path(order_id), params: {order: order_data}

      must_redirect_to order_path(order_id)

      Order.last.status.must_equal "paid"
    end

    it "does not allow the transaction to go through if there are no items in the cart" do
      # create an order item
      orderitem = {product_id: Product.first.id, quantity: Product.first.stock}
      post orderitems_path, params: {order_item: orderitem}

      # delete the order item
      order_id = OrderItem.last.order.id
      delete orderitem_path(OrderItem.last.id)

      # send to update the order w customer info
      order_data = {
        customer_name: "Barry Allen",
        customer_email: "run@nike.com",
        credit_card: "1123581321345589",
        cvv: "890",
        cc_expiration: "09/20",
        shipping_address: "200 Washington St., Central City, NJ, 23456",
        billing_address: "23456"
      }
      patch order_path(order_id), params: {order: order_data}

      must_respond_with :redirect
      Order.last.status.must_equal "pending"
    end

    it "does not allow the transaction to go through if the customer data is incomplete" do
      # create a new order item
      orderitem = {product_id: Product.first.id, quantity: Product.first.stock}
      post orderitems_path, params: {order_item: orderitem}

      # update the order with missing fields
      order_data = {
        customer_name: "Barry Allen",
        credit_card: "1123581321345589",
        cvv: "890",
        shipping_address: "200 Washington St., Central City, NJ, 23456",
        billing_address: "23456"
      }
      patch order_path(session[:cart_id]), params: {order: order_data}

      must_respond_with :bad_request
      Order.last.status.must_equal "pending"
      # relating the cart/order to the order item
      session[:cart_id].must_equal OrderItem.last.order_id
    end

  end # update

  describe 'viewcart' do

    it "sends success if the order exists" do
      order = Order.first
      orderitem_data = { product_id: Product.first.id, quantity: Product.first.stock, order_id: order.id }

      post orderitems_path, params: {order_item: orderitem_data}

      get viewcart_path(order)
      must_respond_with :success
    end

    it "sends not_found if the order does not exist" do
      order_id = Order.last.id + 1
      get viewcart_path(order_id)
      must_respond_with :redirect
      must_redirect_to root_path
    end

  end # viewcart
end
