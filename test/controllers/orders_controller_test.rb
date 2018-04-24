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

    it "sends success if the order exists and status is paid" do
      order = Order.first
      order.status = "paid"
      order.save
      get order_path(order)
      must_respond_with :success
    end

    it "sends not_found if the order does not exist" do
      order_id = Order.last.id + 1
      get order_path(order_id)
      must_respond_with :not_found
    end

    it "redirects to edit_path if order status != paid" do
      order = Order.last
      order.status = "pending"

      get order_path(order)
      must_redirect_to edit_order_path

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
      order = Order.create(status: "pending")

      order_item = OrderItem.create(quantity: 1, product: Product.first, order: order)

      patch order_path(order), params: {
        customer_name: "Barry Allen",
        customer_email: "run@nike.com",
        credit_card: "1123581321345589",
        cvv: "890",
        cc_expiration: "09/20",
        shipping_address: "200 Washington St., Central City, NJ, 23456",
        billing_address: "23456"
      }

      must_redirect_to order_path(order)

      Order.last.status.must_equal "paid"
    end

    it "does not allow the transaction to go through if there are no items in the cart" do
      order = Order.create(status: "pending")

      patch order_path(order), params: {
        customer_name: "Barry Allen",
        customer_email: "run@nike.com",
        credit_card: "1123581321345589",
        cvv: "890",
        cc_expiration: "09/20",
        shipping_address: "200 Washington St., Central City, NJ, 23456",
        billing_address: "23456"
      }

      must_respond_with :redirect

      Order.last.status.must_equal "pending"
    end

    it "does not allow the transaction to go through if the customer data is incomplete" do
      order = Order.create(status: "pending")

      order_item = OrderItem.create(quantity: 1, product: Product.first, order: order)

      patch order_path(order), params: {
        customer_name: "",
        customer_email: "",
        credit_card: "",
        cvv: "",
        cc_expiration: "",
        shipping_address: "",
        billing_address: ""
      }

      must_redirect_to order_path(order)

      Order.last.status.must_equal "paid"
    end

  end # update

  describe 'viewcart' do

    it "sends success if the order exists" do
      order = Order.first
      get viewcart_path(order)
      must_respond_with :success
    end

    it "sends not_found if the order does not exist" do
      order_id = Order.last.id + 1
      get viewcart_path(order_id)
      must_respond_with :not_found
    end

  end # viewcart
end
