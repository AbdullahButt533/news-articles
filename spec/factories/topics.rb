# frozen_string_literal: true

# spec/factories/topics.rb
FactoryBot.define do
  factory :topic do
    title { Faker::Lorem.word }
  end
end
