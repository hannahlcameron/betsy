class Merchant < ApplicationRecord
  has_many :products
  has_many :orders, through: :products

  validates :username, presence: true, uniqueness: true

  validates :email, presence: true, uniqueness: true

end
