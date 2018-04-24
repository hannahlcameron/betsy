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
    return self.quantity * self.product.price
  end


end
