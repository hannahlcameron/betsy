class Product < ApplicationRecord
  has_and_belongs_to_many :categories, join_table: :products_categories
  has_many :reviews
  belongs_to :merchant
  has_many :order_items
  has_many :orders, through: :order_items
end
