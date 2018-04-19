class AddDescriptionToReview < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :description, :text
  end
end
