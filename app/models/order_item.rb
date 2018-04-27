class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :order_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true, :numericality => { :greater_than_or_equal_to => 1, only_integer: true }
  validates :status, presence: true
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
    subtotal = (unit_price * quantity).round(2)
    return subtotal
  end

  def self.existing_oi?(new_oi)
    existing_oi = find_by(product_id: new_oi.product_id, order_id: new_oi.order_id)

    return existing_oi.nil? ? nil : existing_oi
  end


  def self.aggregate_orderitem(new_oi, existing_oi)
    if existing_oi.product_id == new_oi.product_id
      sum = existing_oi.quantity + new_oi.quantity

      unless sum > existing_oi.product.stock # knowing about product quanity
        existing_oi.quantity = sum
      end
    end
    return existing_oi
  end
end
