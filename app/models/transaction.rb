class Transaction < ApplicationRecord
  has_one :user
  has_one :merchant

  validates_presence_of :merchant_id, :user_id, :card_number, :transaction_date, :transaction_amount

  def recommendation
    approved? ? 'approved' : 'denied'
  end
end
