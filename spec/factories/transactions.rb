# == Schema Information
#
# Table name: transactions
#
#  id                 :bigint           not null, primary key
#  card_number        :string           not null
#  transaction_date   :datetime         not null
#  transaction_amount :decimal(, )      not null
#  device_id          :integer
#  chargebacked       :boolean          default(FALSE), not null
#  user_id            :bigint           not null
#  merchant_id        :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  approved           :boolean          not null
#
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
