class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :order_items, :length => { :minimum => 1 }

  def current_order
    @current_order =  OrderItem.where(order_id: @order)
  end

end
