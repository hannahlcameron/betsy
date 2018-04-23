require "test_helper"
require 'pry'

describe OrderItem do

  describe 'validations' do
    it 'is valid with a index_reviews_on_product_id' do

      product_id = Product.first.id
      order_id = Order.first.id
      order_item = OrderItem.new(product_id: product_id, order_id: order_id, quantity: 1)
      order_item.valid?.must_equal true

    end

    it 'is invalid without a product_id' do

      product_id = Product.first.id
      order_id = Order.first.id
      order_item = OrderItem.new(order_id: order_id, quantity: 1)

      order_item.wont_be :valid?

    end

    it 'is valid with an order_id' do

      product_id = Product.first.id
      order_id = Order.first.id
      order_item = OrderItem.new(product_id: product_id, order_id: order_id, quantity: 1)

      order_item.valid?.must_equal true
    end

    it 'is invalid without an order_id' do
      product_id = Product.first.id
      order_id = Order.first.id
      order_item = OrderItem.new(product_id: product_id, order_id: order_id, quantity: 2)

      order_item.valid?.must_equal true

      order_item.order_id = nil

      order_item.valid?.must_equal false
    end

    it 'is valid with a quantity greater than zero' do
      product_id = Product.first.id
      order_id = Order.first.id
      order_item = OrderItem.new(product_id: product_id, order_id: order_id, quantity: 3)

      order_item.valid?.must_equal true

    end

    it 'is invalid when the quantity is not an integer' do
      product_id = Product.first.id
      order_id = Order.first.id
      order_item = OrderItem.new(product_id: product_id, order_id: order_id, quantity: 3)

      order_item.valid?.must_equal true

      order_item.quantity = "potatoes"

      order_item.valid?.must_equal false

    end

    it 'is invalid when the quantity is zero' do
      product_id = Product.first.id
      order_id = Order.first.id
      order_item = OrderItem.new(product_id: product_id, order_id: order_id, quantity: 3)

      order_item.valid?.must_equal true

      order_item.quantity = 0

      order_item.valid?.must_equal false
    end

    it 'is invalid with a quantity greater than the product stock' do
      product = Product.first
      order = Order.first
      stock = product.stock
      order_item = OrderItem.new(product_id: product.id, order_id: order.id, quantity: stock + 1)
      order_item.wont_be :valid?
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
        order_item = OrderItem.new(quantity: quantity, product_id: product.id, order_id: order.id)
        order_item.must_be :valid?
        subtotal = product.price * quantity
        result = order_item.subtotal
        result.must_equal subtotal
      end

    end # subtotal

  end # business logic

end
