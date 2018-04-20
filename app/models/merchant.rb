class Merchant < ApplicationRecord
  has_many :products
  # has many orders through products
end
