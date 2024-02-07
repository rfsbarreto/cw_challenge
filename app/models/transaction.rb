# frozen_string_literal: true

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
class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :merchant

  validates_presence_of :merchant_id, :user_id, :card_number, :transaction_date, :transaction_amount
  validates :id, uniqueness: true

  scope :by_user, ->(user_id) { where(user_id:) }
  scope :number_of_transactions_by_timeframe, lambda { |start_time:, end_time:|
                                                where(transaction_date: start_time..end_time).count
                                              }
  scope :with_chargeback, -> { where(chargebacked: true) }
  scope :weekly, -> { where(transaction_date: 1.week.ago..Time.now) }

  def recommendation
    approved? ? 'approved' : 'denied'
  end
end
