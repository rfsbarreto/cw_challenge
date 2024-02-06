class User < ApplicationRecord
  has_many :transactions

  def transaction_amount_limit
    max_transaction_amount || ENV['DEFAULT_MAX_TRANSACTION_AMOUNT'].to_f
  end
end
