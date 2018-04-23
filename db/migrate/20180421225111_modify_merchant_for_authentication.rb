class ModifyMerchantForAuthentication < ActiveRecord::Migration[5.1]
  def change
    add_column :merchants, :uid, :integer, options: { null: false }
    add_column :merchants, :provider, :string, options: { null: false }
  end
end
