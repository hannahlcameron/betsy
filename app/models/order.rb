class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :order_items, length: { minimum: 1 }, if: :customer_info?

  def customer_info?
    if self.customer_name.nil? || self.customer_email.nil? || self.credit_card.nil? || self.CVV.nil? || self.CC_expiration.nil? || self.shipping_address.nil? || self.billing_address.nil?
      return false
    end
    return true
  end
end
