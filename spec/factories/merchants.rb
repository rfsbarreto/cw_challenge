FactoryBot.define do
  factory :merchant do
    number_transactions { 1 }
    block_transactions { false }
    number_chargebacks { 1 }
    total_value { 1.5 }
  end
end
