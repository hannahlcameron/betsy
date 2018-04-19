class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.string :customer_email
      t.string :credit_card
      t.string :CVV
      t.string :CC_expiration
      t.string :status
      t.string :shipping_address
      t.string :billing_address

      t.timestamps
    end
  end
end
