# == Schema Information
#
# Table name: merchants
#
#  id                  :bigint           not null, primary key
#  number_transactions :integer          default(0), not null
#  block_transactions  :boolean          default(FALSE), not null
#  number_chargebacks  :integer          default(0), not null
#  total_value         :decimal(, )      default(0.0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :merchant do
    number_transactions { 1 }
    block_transactions { false }
    number_chargebacks { 1 }
    total_value { 1.5 }
  end
end
