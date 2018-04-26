class Product < ApplicationRecord
  has_and_belongs_to_many :categories, join_table: :products_categories
  has_many :reviews, dependent: :destroy
  belongs_to :merchant
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  accepts_nested_attributes_for :categories

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: {greater_than: 0}
  validates :stock, numericality: { greater_than: 0 }

  scope :by_category, -> (category_name) { where(retired: false).joins(:categories).merge(Category.where(name: category_name)) }

  def stock_decrement(quantity)
    stock = self.stock - quantity
    self.update(stock: stock)
  end
end
