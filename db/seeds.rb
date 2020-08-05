# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Merchant.destroy_all
Item.destroy_all

#users
tony = User.create(name: "Tony Tiger", address: "345 Frosty St", city: "Denver",
                  state: "CO", zip: 80205, email: "grrreat_hooray@gmail.com",
                  password: "123test", password_confirmation: "123test", role: 0)

chester = User.create(name: "Chester Cheetah", address: "455 Hot Fiyah Ave", city: "Phoenix",
                  state: "AZ", zip: 85253, email: "hunnidmilesrunnin@gmail.com",
                  password: "123test", password_confirmation: "123test", role: 1)
cuckoo = User.create(name: "Sonny Cuckoo", address: "822 Cocoa River Ln", city: "Los Angeles",
                  state: "CA", zip: 90008, email: "cuckoo4cocoa@gmail.com",
                  password: "123test", password_confirmation: "123test", role: 1)

admin = User.create(name: "Mufasa Lyons", address: "388 Pride Rock Cir", city: "San Diego",
                  state: "CA", zip: 92102, email: "circleoflife2@gmail.com",
                  password: "123test", password_confirmation: "123test", role: 2)

#merchants
sports = Merchant.create(name: "Santiago's Sporting Goods", address: "45 Nature Bliss St", city: "San Diego", state: "CA", zip: 92102)
music = Merchant.create(name: "Marley's Music", address: "1 Mother Nature Cir", city: "San Diego", state: "CA", zip: 92109)

#items
bball = sports.items.create(name: "Basketball", description: "Ballislife!", price: 30.00,
                    image: "https://image-cdn.hypb.st/https%3A%2F%2Fhypebeast.com%2Fimage%2F2020%2F05%2Fnba-drops-spalding-basketball-for-wilson-2021-season-1.jpg?q=80&w=1000&cbr=1&fit=max",
                    inventory: 45, active: true)
fball = sports.items.create(name: "Football", description: "Go long!", price: 25.00,
                    image: "https://dks.scene7.com/is/image/GolfGalaxy/19NIKUVPR24720FFFFTB?qlt=70&wid=992&fmt=pjpeg",
                    inventory: 40, active: true)
v_lap = music.items.create(name: "Victory Lap", description: "By Nipsey Hussle", price: 15.00,
                    image: "https://upload.wikimedia.org/wikipedia/en/thumb/4/46/Nipsey_Hussle_–_Victory_Lap.png/220px-Nipsey_Hussle_–_Victory_Lap.png",
                    inventory: 30, active: true)
oxnard = music.items.create(name: "Oxnard", description: "By Anderson .Paak", price: 15.00,
                    image: "https://consequenceofsound.net/wp-content/uploads/2018/10/anderson-paak-oxnard-album-cover-artwork.jpg",
                    inventory: 35, active: true)

#discounts
discount_1 = sports.discounts.create!(name: "10% off 5 or more items", min_item_quantity: 5, percent_off: 10)
discount_2 = sports.discounts.create!(name: "20% off 10 or more items", min_item_quantity: 10, percent_off: 20)
discount_3 = music.discounts.create!(name: "10% off 5 or more items", min_item_quantity: 5, percent_off: 10)
discount_4 = music.discounts.create!(name: "15% off 10 or more items", min_item_quantity: 10, percent_off: 15)

#orders
order_1 = tony.orders.create(status: "pending")
order_2 = tony.orders.create(status: "pending")
order_3 = tony.orders.create(status: "shipped")
order_1.order_items.create(item: bball, price: bball.price, quantity: 5, fulfilled: false)
order_2.order_items.create(item: bball, price: bball.price, quantity: 1, fulfilled: false)
order_2.order_items.create(item: fball, price: fball.price, quantity: 2, fulfilled: false)
order_3.order_items.create(item: v_lap, price: v_lap.price, quantity: 12, fulfilled: true)
order_3.order_items.create(item: oxnard, price: oxnard.price, quantity: 8, fulfilled: true)
