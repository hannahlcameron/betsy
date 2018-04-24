class Merchant < ApplicationRecord
  has_many :products, dependent: :destroy
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

  def total_revenue_by(status)
    orders_and_items = self.merchant_order_items
    total_revenue = 0.00
    orders_and_items.each do |order, order_items|
      order_items.each do |order_item|
        if Order.find(order).status == status || status == "all"
          total_revenue += order_item.subtotal
        end
      end
    end
    return total_revenue
  end # total_revenue_by

  def count_orders_by(status)
    count = 0
    orders = self.orders.distinct
    orders.each do |order|
      if order.status == status || status == "all"
        count += 1
      end
    end
    return count
  end # count_orders_by

end
