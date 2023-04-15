# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    source { { id: Faker::Number.number, name: Faker::Lorem.word } }
    description { Faker::Lorem.sentence }
    url { Faker::Internet.url }
    url_to_image { Faker::Internet.url }
    content { Faker::Lorem.paragraph }
    published_at { Faker::Time.between(from: 2.days.ago, to: Time.zone.now) }
    association :topic, factory: :topic
    association :author, factory: :author
  end
end
