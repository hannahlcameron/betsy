class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :order_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true, :numericality => { :greater_than_or_equal_to => 1 }
  validates_numericality_of :quantity, only_integer: true
end
