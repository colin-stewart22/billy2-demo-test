# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "Destroy OrderItem database..."
OrderItem.destroy_all
puts "Destroy JoinMenu database..."
JoinMenu.destroy_all
puts "Destroy Menu database..."
Menu.destroy_all
puts "Destroy MenuItem database..."
MenuItem.destroy_all
puts "Destroy TableCustomer database..."
TableCustomer.destroy_all
puts "Destroy TableOrder database..."
TableOrder.destroy_all
puts "Destroy Table database..."
Table.destroy_all
puts "Destroy RestaurantServer database..."
RestaurantServer.destroy_all
puts "Destroy Restaurant database..."
Restaurant.destroy_all
puts "Destroy User database..."
User.destroy_all

puts "Create Owner database..."

owner = User.create!(
  email: "Owner@lewagon.com",
  password: "lewagon",
  first_name: "Owner",
  last_name: "lewagon",
  is_owner: true
)

puts "Create Restaurant database..."

restaurant = Restaurant.create!(
  name: Faker::Restaurant.name,
  address: "204 Brick Lane Shoreditch, London, E1 6SA, England",
  phone_number: Faker::PhoneNumber.cell_phone_in_e164,
  theme_color: "blue",
  user_id: owner.id
)

puts "Create Mario database..."

mario = User.create!(
  email: "mario@lewagon.com",
  password: "lewagon",
  first_name: "Mario",
  last_name: "lewagon",
  is_owner: false
)

RestaurantServer.create!(
  restaurant_id: restaurant.id,
  user_id: mario.id
)

puts "Create Luca database..."

luca = User.create!(
  email: "luca@lewagon.com",
  password: "lewagon",
  first_name: "Luca",
  last_name: "lewagon",
  is_owner: false
)

RestaurantServer.create!(
  restaurant_id: restaurant.id,
  user_id: luca.id
)

puts "Create Sara database..."

sara = User.create!(
  email: "sara@lewagon.com",
  password: "lewagon",
  first_name: "Sara",
  last_name: "lewagon",
  is_owner: false
)

RestaurantServer.create!(
  restaurant_id: restaurant.id,
  user_id: sara.id
)

puts "Create 3 Table database..."

i = 1

3.times do
  Table.create!(
    restaurant_id: restaurant.id,
    table_number: i,
    qr_code: "http://www.billy-961.com/restaurants/#{restaurant.id}/tables/#{i}/table_orders/new"
  )

  i += 1
end

puts "Completed!"
