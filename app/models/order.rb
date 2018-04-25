class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  # validates :order_items, :length => { :minimum => 1 }
  validates :customer_name, presence: true, on: :update
  validates :customer_email, presence: true, on: :update
  validates :credit_card, presence: true, on: :update
  validates :cvv, presence: true, on: :update
  validates :cc_expiration, presence: true, on: :update
  validates :shipping_address, presence: true, on: :update
  validates :billing_address, presence: true, on: :update

  validates :order_items, length: { minimum: 1 }, if: :customer_info?

  def customer_info?
    if
      self.customer_name.nil? || self.customer_email.nil? || self.credit_card.nil? || self.cvv.nil? || self.cc_expiration.nil? || self.shipping_address.nil? || self.billing_address.nil?
      return false
    end
    return true
  end
  def order_total
    total = 0
    purchased_items = self.order_items.where(order_id: self)
    purchased_items.each do |item|
      total += item.subtotal
    end
    return total
  end
end
