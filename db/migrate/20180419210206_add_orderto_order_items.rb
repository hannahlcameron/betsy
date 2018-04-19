class AddOrdertoOrderItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :order_items, :order_id, :integer

    add_reference :order_items, :order, foreign_key: true
  end
end
