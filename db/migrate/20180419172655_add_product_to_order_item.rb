class AddProductToOrderItem < ActiveRecord::Migration[5.1]
  def change
    remove_column :order_items, :product_id, :integer
    add_reference :order_items, :product, foreign_key: true
  end
end
