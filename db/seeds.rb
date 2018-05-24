# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def seed_demo_password
  'buy nsw dev account'
end

def seed_user_account(email, role)
  user = User.find_or_initialize_by(email: email)

  user.password = seed_demo_password
  user.password_confirmation = seed_demo_password
  user.roles << role
  user.save!

  puts "\nUser created!\n"
  puts "\tUsername:\t#{user.email}"
  puts "\tPassword:\t#{user.password}"
  puts "\tRole:\t\t#{role}"
  puts "\n"
end

seed_user_account('admin@dev.buy.nsw.gov.au', 'admin')
seed_user_account('seller@dev.buy.nsw.gov.au', 'seller')
seed_user_account('buyer@dev.buy.nsw.gov.au', 'buyer')
