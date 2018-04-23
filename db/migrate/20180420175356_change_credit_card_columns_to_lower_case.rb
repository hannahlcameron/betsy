class ChangeCreditCardColumnsToLowerCase < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders, :CVV, :cvv
    rename_column :orders, :CC_expiration, :cc_expiration
  end
end
