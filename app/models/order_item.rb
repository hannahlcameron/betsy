class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validate :available_quantity

  def available_quantity
    unless product.stock >= quantity
      errors[:quantity] << 'Not enough stock'
    end
  end

  def subtotal
    unit_price = self.product.price
    quantity = self.quantity
    subtotal = unit_price * quantity
    return subtotal
  end

end
