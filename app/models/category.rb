class Category < ApplicationRecord
  has_and_belongs_to_many :products, join_table: :products_categories

  validates :name, presence: true, uniqueness: true

  def self.categories_with_works
    return Category.find_by_sql('SELECT DISTINCT categories.name FROM categories INNER JOIN products_categories ON categories.id = products_categories.category_id INNER JOIN products ON products_categories.category_id = products.id')
  end
end
