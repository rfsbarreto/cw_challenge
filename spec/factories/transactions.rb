FactoryBot.define do
  factory :transaction do
    card_number { "MyString" }
    transaction_date { "2024-02-03 21:13:38" }
    transaction_amount { 1.5 }
    device_id { 1 }
  end
end
