class ChangeProductStockToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :stock, :integer, using: 'stock::integer'
  end
end
