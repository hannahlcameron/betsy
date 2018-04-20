class AddStatusToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :retired, :boolean, default: false
  end
end
