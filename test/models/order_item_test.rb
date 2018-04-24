require "test_helper"

describe OrderItem do

  describe 'subtotal' do
    before do
      @orderitem = OrderItem.first
    end
    it 'returns the subtotal when quantity is 1' do
      @orderitem.quantity = 1

      subtotal = @orderitem.subtotal

      subtotal.must_equal @orderitem.product.price

    end

    it 'returns the subtotal when quantity is > 1' do
      @orderitem.quantity = 3

      subtotal = @orderitem.subtotal

      subtotal.must_equal (@orderitem.product.price * @orderitem.quantity)
    end
  end

end
