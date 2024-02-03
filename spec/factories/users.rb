FactoryBot.define do
  factory :user do
    number_transactions { 1 }
    block_transactions { false }
    total_value { 1.5 }
  end
end
