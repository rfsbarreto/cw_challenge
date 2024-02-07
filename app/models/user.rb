# frozen_string_literal: true

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
class User < ApplicationRecord
  has_many :transactions

  def transaction_amount_limit
    max_transaction_amount || ENV['DEFAULT_MAX_TRANSACTION_AMOUNT'].to_f
  end
end
