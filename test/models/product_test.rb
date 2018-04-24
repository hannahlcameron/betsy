require "test_helper"

describe Product do
  describe 'relations' do
    let (:product) { Product.new(name: 'Action Figure', stock: 3, price: 2.99, merchant: merchants(:merchant_one)) }
    let (:merchant) { Merchant.first }

    it 'has a list of categories' do
      product = products(:batarang)

      product.must_respond_to :categories

      product.categories.each do |category|
        category.must_be_kind_of Category
      end
    end

    it 'connects categories and products' do
      category = Category.first

      product.categories.push(category)

      product.valid?.must_equal true

      product.categories.must_include category
    end


    it 'connects products and merchants' do
      product = Product.new(name: 'Green Hair Dye', stock: 24, price: 8.99, merchant_id: merchant.id)

      product.merchant_id.must_equal merchant.id
    end

    it 'connects products and order_items' do
      order_item = order_items(:one)

      product = Product.create!(name: 'Green Hair Dye', stock: 24, price: 8.99, merchant_id: merchant.id)

      product.order_items << order_item
      product.valid?.must_equal true
      product.order_item_ids.must_include order_item.id
    end

    it 'connects products and orders' do
      product1 = Product.create!(name: 'Green Hair Dye', stock: 24, price: 8.99, merchant_id: merchant.id)

      order = Order.create!
      OrderItem.create!(product_id: product1.id, order_id: order.id, quantity: 2)

      product1.valid?.must_equal true
      product1.order_ids.must_include order.id
    end
  end

  describe 'validations' do
    let (:merchant) { Merchant.first }
    let (:categories) { [Category.first] }

    it 'cannot be created without a name' do
      product_data = {
        stock: 1,
        price: 1.99,
        merchant_id: merchant.id,
        categories: categories
      }

      product = Product.new(product_data)

      product.valid?.must_equal false
      product.errors.messages.must_include :name
    end

    it 'must have a unique name' do
      product1_name = Product.first.name

      product2_data = {
        name: product1_name,
        stock: 1,
        price: 1.99,
        merchant_id: merchant.id,
        categories: categories
      }

      product = Product.new(product2_data)

      product.valid?.must_equal false
      product.errors.messages.must_include :name
    end

    it 'cannot be created without a price' do
      product_data = {
        name: 'product',
        stock: 1,
        merchant_id: merchant.id,
        categories: categories
      }

      product = Product.new(product_data)

      product.valid?.must_equal false
      product.errors.messages.must_include :price
    end

    it 'cannot be created with a price below 0' do
      product_data = {
        name: 'product',
        stock: 1,
        price: -2.4,
        merchant_id: merchant.id,
        categories: categories
      }

      product = Product.new(product_data)
      product.valid?.must_equal false
      product.errors.messages.must_include :price
    end

    it 'cannot be created without a stock' do
      product_data = {
        name: 'product',
        price: 2.99,
        stock: nil,
        merchant_id: merchant.id,
        categories: categories
      }

      product = Product.new(product_data)

      product.valid?.must_equal false
      product.errors.messages.must_include :stock
    end

    it 'cannot be created without a merchant ID' do
      product_data = {
        name: 'product',
        stock: 1,
        price: 2.4,
        categories: categories
      }

      product = Product.new(product_data)
      product.valid?.must_equal false
      product.errors.messages.must_include :merchant
    end

    it 'can be created with appropriate data' do
      product_data = {
        name: 'product',
        stock: 1,
        price: 2.4,
        merchant_id: merchant.id,
        categories: categories
      }
      old_product_count = Product.count

      product = Product.create(product_data)
      product.valid?.must_equal true
      Product.count.must_equal old_product_count + 1
    end
  end

  describe 'scopes' do
    describe 'by_category' do
      it 'returns only the products of a specific category' do
        category = Category.first

        products = Product.by_category(category.name)

        products.each do |product|
          product.categories.must_include category
        end
      end


    end
  end
end
