class AddPlacedOnColumnToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :placed_on, :date
  end
end
