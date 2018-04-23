class MakeMerchantUidBigInt < ActiveRecord::Migration[5.1]
  def change
    change_column :merchants, :uid, :integer, limit: 8
  end
end
