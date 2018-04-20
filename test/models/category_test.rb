require "test_helper"

describe Category do
  describe 'relations' do
    it 'connects category and products' do
      product = Product.first

      category = Category.new(name: 'Accessories')
      category.products.push(product)

      category.valid?.must_equal true
      category.products.must_include product
    end
  end
end
