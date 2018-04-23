class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :order_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true, :numericality => { :greater_than_or_equal_to => 1, only_integer: true }
  validate :available_quantity

  def available_quantity
    if product
      unless product.stock >= quantity
        errors[:quantity] << 'Not enough stock'
      end
    end
  end

  def subtotal
    unit_price = self.product.price
    quantity = self.quantity
    subtotal = unit_price * quantity
    return subtotal
  end

end
