require "test_helper"

describe Product do
  describe 'relations' do
    let (:product) { Product.new(name: 'Action Figure', stock: 3, price: 2.99, merchant: merchants(:merchant_one)) }

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
      merchant = Merchant.first

      product = Product.new(name: 'Green Hair Dye', stock: 24, price: 8.99, merchant_id: merchant.id)

      product.merchant_id.must_equal merchant.id
    end
  end

  describe 'validations' do
    it 'cannot be created without a name' do
      merchant = Merchant.first
      categories = [Category.first]

      product_data = {
        stock: 1,
        price: 1.99,
        merchant_id: merchant.id,
        categories: categories
      }

      product = Product.new(product_data)

      product.valid?.must_equal false
      product.error.messages.must_include :name
    end
  end
end
