require "test_helper"

describe OrderItem do
  describe 'validation' do
    it 'is valid with a index_reviews_on_product_id' do

      product_id = Product.first.id
      order_item = OrderItem.new
      order_item.valid?.must_equal false
      order_item.product_id.push(product_id)

    end

    it 'is invalid without a product_id' do


    end

    it 'is valid with an order_id' do

    end

    it 'is valid without an order_id' do

    end

    it 'is valid with a quantity greater than zero' do

    end

    it 'is invalid when the quantity is not an integer' do

    end

    it 'is invalid when the quantity is zero' do

    end

  end
end
