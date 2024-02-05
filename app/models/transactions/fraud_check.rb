# frozen_string_literal: true

module Transactions
  class FraudCheck
    def initialize(transaction:, user:, merchant:)
      @transaction = transaction
      @user = user
      @merchant = merchant
    end

    def transaction_cleared?
      return false if @user.block_transactions?
      return false if @merchant.block_transactions?
      return false if transaction_above_user_limit?
      return false if too_much_transactions_within_timeframe?

      true
    end

    private

    def transaction_above_user_limit?
      transaction[:amount] > @user.max_transaction_amount
    end

    def too_much_transactions_within_timeframe?
      false
    end
  end
end
