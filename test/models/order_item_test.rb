require "test_helper"
require 'pry'

describe OrderItem do

  describe 'validations' do
    before do
      @product = Product.first
      @order = Order.first
      @order_item = OrderItem.new(product_id: @product.id, order_id: @order.id, quantity: 1, status: "pending")
    end

    it 'is valid with a index_reviews_on_product_id' do

      @order_item.valid?.must_equal true

    end

    it 'is invalid without a product_id' do

      order_item = OrderItem.new(order_id: @order_id, quantity: 1)

      order_item.wont_be :valid?

    end

    it 'is valid with an order_id' do

      @order_item.valid?.must_equal true

    end

    it 'is invalid without an order_id' do
      @order_item.valid?.must_equal true

      @order_item.order_id = nil

      @order_item.valid?.must_equal false
    end

    it 'is valid with a quantity greater than zero' do
      @order_item.quantity = 3
      @order_item.quantity.must_equal 3
      @order_item.valid?.must_equal true
    end

    it 'is invalid when the quantity is not an integer' do
      @order_item.valid?.must_equal true

      @order_item.quantity = "potatoes"

      @order_item.valid?.must_equal false

    end

    it 'is invalid when the quantity is zero' do
      @order_item.valid?.must_equal true

      @order_item.quantity = 0

      @order_item.valid?.must_equal false
    end

    it 'is invalid with a quantity greater than the product stock' do
      stock = @product.stock
      @order_item.quantity = stock + 1
      @order_item.wont_be :valid?
    end

    it 'is invalid without a status' do
      @order_item.must_be :valid?
      @order_item.status = nil
      @order_item.wont_be :valid?
    end

  end # validations

  describe "relations" do
    before do
      @order_item = OrderItem.new
    end


    it "connects product and product id" do
      product = Product.first
      @order_item.product = product
      @order_item.product_id.must_equal product.id
    end

    it "connects order and order id" do
      order = Order.first
      @order_item.order = order
      @order_item.order_id.must_equal order.id
    end

  end # relations

  describe "business logic" do

    describe "subtotal" do

      it "returns the price of the product times the quantity of the order item" do
        product = Product.first
        quantity = 2
        order = Order.create
        order_item = OrderItem.new(quantity: quantity, product_id: product.id, order_id: order.id, status: "pending")
        order_item.must_be :valid?
        subtotal = product.price * quantity
        result = order_item.subtotal
        result.must_equal subtotal
      end

    end # subtotal

    describe 'orderitem aggregation' do
      it 'will update an order item quantity' do
        product1 = Product.first
        order = Order.create!

        orderitem1 = OrderItem.create!(product_id: product1.id, quantity: 1, order_id: order.id)

        orderitem2 = OrderItem.new(product_id: orderitem1.product_id, quantity: 1, order_id: order.id)

        # return orderitem2
        orderitem_test = OrderItem.aggregate_orderitem(orderitem2, orderitem1)

        orderitem_test.save

        orderitem1.quantity.must_equal 2
        orderitem_test.id.must_equal orderitem1.id

        product_ones = order.products.select { |product| product.id == product1.id }

        product_ones.length.must_equal 1
      end
    end

    describe 'existing_oi?' do
      it "will return true if order item's product is already associated with the order" do
        product1 = Product.first
        order = Order.create!

        orderitem1 = OrderItem.create!(product_id: product1.id, quantity: 1, order_id: order.id)

        orderitem2 = OrderItem.new(product_id: product1.id, quantity: 1, order_id: order.id)
        result = OrderItem.existing_oi?(orderitem2)

        result.must_equal orderitem1
      end

      it 'will return nil if that product is not associated with the order' do
        product1 = Product.first
        order = Order.create!

        OrderItem.create!(product_id: product1.id, quantity: 1, order_id: order.id)

        orderitem2 = OrderItem.new(product_id: Product.last.id, quantity: 1, order_id: order.id)
        
        result = OrderItem.existing_oi?(orderitem2)
        result.must_equal nil
      end
    end
  end # business logic

end
