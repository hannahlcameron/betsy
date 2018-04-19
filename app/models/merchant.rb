class Merchant < ApplicationRecord
  has_many :products
<<<<<<< HEAD

  validates :username, presence: true, uniqueness: true

  validates :email, presence: true, uniqueness: true
=======
>>>>>>> master
end
