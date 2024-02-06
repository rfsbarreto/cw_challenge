FactoryBot.define do
  factory :transaction do
    id { Faker::Number.number }
    card_number { "#{Faker::Number.number(digits: 4)}****#{Faker::Number.number(digits: 4)}" }
    transaction_date { '2024-02-03 21:13:38' }
    transaction_amount { 1.5 }
    device_id { 1 }
    approved { Faker::Boolean.boolean }
    user
    merchant
  end
end
