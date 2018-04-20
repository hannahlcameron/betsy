class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validate :available_quantity

  def available_quantity
    unless product.stock.to_i >= quantity
      errors[:quantity] << 'Not enough stock'
    end
  end

end
