# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Admin User
User.create!(
  email: 'test_admin@test.com',
  password: 'Test123@',
  password_confirmation: 'Test123@',
  confirmed_at: Time.zone.now,
  role: 'admin'
)

# Reader

User.create!(
  email: 'test_reader@test.com',
  password: 'Test123@',
  password_confirmation: 'Test123@',
  confirmed_at: Time.zone.now
)

# uncomment to add these readers

# User.create!(email: 'syedanabimam@gmail.com', password: 'Test123@', password_confirmation: 'Test123@')
# User.create!(email: 'anab@amprotocolabs', password: 'Test123@', password_confirmation: 'Test123@')
