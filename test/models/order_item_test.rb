require "test_helper"

describe OrderItem do
  describe 'validation' do
    it 'is valid with a index_reviews_on_product_id' do

      product_id = Product.first.id
      order_id = Order.first.id
      order_item = OrderItem.new(product_id: product_id, order_id: order_id, quantity: 5)

      order_item.valid?.must_equal true

    end

    it 'is invalid without a product_id' do

      product_id = Product.first.id
      order_id = Order.first.id
      order_item = OrderItem.new(product_id: product_id, order_id: order_id, quantity: 24)

      order_item.valid?.must_equal true

      order_item.product_id = nil

      order_item.valid?.must_equal false

    end

    it 'is valid with an order_id' do

      product_id = Product.first.id
      order_id = Order.first.id
      order_item = OrderItem.new(product_id: product_id, order_id: order_id, quantity: 9)

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

  end
end
