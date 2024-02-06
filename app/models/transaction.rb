# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :merchant

  validates_presence_of :merchant_id, :user_id, :card_number, :transaction_date, :transaction_amount

  scope :by_user, ->(user_id) { where(user_id:) }
  scope :number_of_transactions_by_timeframe, lambda { |time_in_seconds:|
                                                where(transaction_date: (Time.now - time_in_seconds)..Time.now).count
                                              }

  def recommendation
    approved? ? 'approved' : 'denied'
  end
end
