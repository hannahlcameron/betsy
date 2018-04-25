# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

category_names = ['accessories', 'capes', 'stickers', 'utility', 'media']

unsaved_categories = []
category_names.each do |category|
  category = Category.new(name: category)
  successful = category.save

  if !successful
    unsaved_categories << category.name
  end
end
puts "#{unsaved_categories.count} categories not saved"


merchants = ['wonder pig', 'captain dog', 'professor heggie', 'batcat']
unsaved_merchants = []
merchants.each do |name|
  merchant = Merchant.new
  merchant.username = name
  merchant.email = name.gsub(' ', '_').concat('@superpet.com')
  merchant.uid = rand(10000..99999).to_s
  merchant.provider = 'google_oauth2'

  successful = merchant.save

  if !successful
    unsaved_merchants << merchant.name
  end
end

puts "#{unsaved_merchants.count} merchants not saved"
category_hash = {}
Category.all.map {|category| category_hash[category.name] = category}

product_names = [
  ['Green Lantern', 'https://images-na.ssl-images-amazon.com/images/I/51ByMhmwMWL._SY879_.jpg', [category_hash['utility'],] ],
  ['Ms Marvel Stickers', 'https://i.pinimg.com/236x/36/dc/70/36dc7094fef7a1db3596db10eee68a07--ms-marvel-sticker.jpg', [ category_hash['stickers'], category_hash['accessories']] ],
  ['Batarang', 'https://www.thinkgeek.com/images/products/zoom/httq_batman_batarang_letter_opener.jpg', [category_hash['utility'], category_hash['accessories']] ],
  ['Black Eye Mask', 'http://www.5050factoryoutlet.com/istarimages/mp/395936-10!02-30648_d.jpg', [category_hash['accessories']]],
  ['Yellow Cape', 'https://i.pinimg.com/736x/b1/c6/d1/b1c6d16f5d0cc1ea35ff4344f1aaa386--halloween-costumes-for-dogs-pet-costumes.jpg', [category_hash['accessories'], category_hash['capes']]],
  ['Entire Capain Planet Series on VHS', 'https://img1.etsystatic.com/142/0/5844803/il_570xN.1130347923_5jxi.jpg', [category_hash['media']]],
  ['Storm Wig', 'https://ssli.ebayimg.com/images/g/Mv8AAOSwLN5WiOXY/s-l640.jpg', [category_hash['accessories']]],
  ['Black Widdow Utility Cuffs', 'https://img.etsystatic.com/il/42fa43/1103666807/il_340x270.1103666807_fn4o.jpg?version=0', [category_hash['accessories'], category_hash['utility']] ],
  ['Red Hair Dye', 'https://www.softsheen-carson.com/~/media/Images/SoftsheenUS/Dark%20and%20Lovely/ALL_GO%20INTENSE%20SPICY%20RED_1000x1000.jpg', [category_hash['accessories']]]
]

unsaved_products = []
product_names.each do |product|
  prod = Product.new
  prod.merchant_id = Merchant.all.sample.id
  prod.name = product[0]
  prod.stock = rand(1..10)
  prod.price = rand(1..100)
  prod.photo_url = product[1]
  prod.categories = product[2]

  successful = prod.save!
  if !successful
    unsaved_products << prod.name
  end
end
puts "#{unsaved_products.count} products not saved"

unsaved_orderitems = []
5.times do
  orderitem = OrderItem.new
  product = Product.all.sample
  orderitem.product_id = product.id
  orderitem.quantity = rand(1..product.stock)
  orderitem.order_id = Order.create!.id

  successful = orderitem.save!
  if !successful
    unsaved_orderitems << orderitem
  end
end

puts "#{unsaved_orderitems.count} orderitems not saved"
