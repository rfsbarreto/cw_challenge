# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  number_transactions    :integer          default(0), not null
#  block_transactions     :boolean          default(FALSE), not null
#  total_value            :decimal(, )      default(0.0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  max_transaction_amount :decimal(, )
#
FactoryBot.define do
  factory :user do
    number_transactions { 1 }
    block_transactions { false }
    total_value { 1.5 }
  end
end
