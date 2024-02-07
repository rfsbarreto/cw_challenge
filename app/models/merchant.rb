# frozen_string_literal: true

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
class Merchant < ApplicationRecord
  has_many :transactions
end
