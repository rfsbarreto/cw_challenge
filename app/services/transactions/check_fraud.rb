# frozen_string_literal: true

module Transactions
  class CheckFraud
    TRANSACTIONS_TIMEFRAME = 2.minutes
    MAX_TRANSACTIONS_PER_TIMEFRAME = 3

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
      @transaction.transaction_amount > @user.transaction_amount_limit
    end

    def too_much_transactions_within_timeframe?
      number_of_transactions = @user
                               .transactions
                               .number_of_transactions_by_timeframe(time_in_seconds: TRANSACTIONS_TIMEFRAME)

      number_of_transactions > MAX_TRANSACTIONS_PER_TIMEFRAME
    end
  end
end
