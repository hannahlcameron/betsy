class Merchant < ApplicationRecord
  has_many :products
  has_many :orders, through: :products

  validates :username, presence: true, uniqueness: true

  validates :email, presence: true, uniqueness: true

  def merchant_order_items

    orders_and_items = {}
    orders = self.orders
    order_ids = orders.map { |order| order.id }
    order_ids.each { |order_id| orders_and_items[order_id] = [] }

    order_items = []
    self.products.each { |product|
      product.order_items.each { |order_item|
        order_items << order_item
      }
    }

    order_items.each { |order_item|
      orders_and_items[order_item.order_id] << order_item
    }

    return orders_and_items

  end # merchant_order_items

end
