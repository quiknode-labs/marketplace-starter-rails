# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    association :account
    email { Faker::Internet.email }
    name { Faker::Name.name }
  end

  factory :account do
    quicknode_id { Faker::Number.number(digits: 7) }
    plan_slug { 'launch' }
    is_test { false }
  end

  factory :endpoint do
    association :account
    chain { 'ethereum' }
    network { 'mainnet' }
    quicknode_id { Faker::Number.number(digits: 7) }
    http_url { Faker::Internet.url }
    wss_url { Faker::Internet.url }
    is_test { false }
  end
end