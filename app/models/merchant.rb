class Merchant < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :orders, through: :products

  validates :username, presence: true, uniqueness: true

  validates :email, presence: true, uniqueness: true

  def merchant_order_items(status)

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
      order_status = Order.find_by(id: order_item.order_id).status
      if order_status == status || status == "all"
        orders_and_items[order_item.order_id] << order_item
      end
    }

    orders_and_items.each do |order, order_items|
      if order_items.empty?
        orders_and_items.delete(order)
      end
    end

    return orders_and_items

  end # merchant_order_items

  def total_revenue_by(status)
    orders_and_items = self.merchant_order_items("all")
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

  def self.get_user(data_hash)
    merchant = Merchant.find_by(uid: data_hash['uid'], provider: data_hash['provider'])

    if merchant.nil?
      merchant_data = {
        uid: data_hash['uid'],
        provider: data_hash['provider'],
        username: data_hash['info']['name'],
        email: data_hash['info']['email']
      }

      merchant = Merchant.new(merchant_data)
      return merchant.save ? merchant : nil
    end
    return merchant
  end

end
