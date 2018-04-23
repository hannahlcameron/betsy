class MakeMerchantUidBigger < ActiveRecord::Migration[5.1]
  def change
    change_column :merchants, :uid, :bigint
  end
end
