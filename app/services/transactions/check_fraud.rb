# frozen_string_literal: true

module Transactions
  # The CheckFraud Service class is responsible for checking if a transaction is fraudulent
  class CheckFraud
    SUBSEQUENT_TIMEFRAME = (ENV['SUBSEQUENT_TRANSACTIONS_TIMEFRAME'] || 2).to_i.minutes
    MAX_TRANSACTIONS_PER_TIMEFRAME = ENV['MAX_TRANSACTIONS_PER_TIMEFRAME'].to_i || 3

    # Initialize the CheckFraud instance
    #
    # @param transaction [Transaction] The transaction to be checked
    # @param user [User] The user associated with the transaction
    # @param merchant [Merchant] The merchant associated with the transaction
    def initialize(transaction:, user:, merchant:)
      @transaction = transaction
      @user = user
      @merchant = merchant
    end

    # Checks if the transaction should be cleared through 4
    # predetermined rules
    #
    # @return [Boolean] true if the transaction is cleared, false otherwise
    def transaction_cleared?
      return false if @user.block_transactions?
      return false if @merchant.block_transactions?
      return false if transaction_above_user_limit?
      return false if too_much_transactions_within_timeframe?(transaction_date: @transaction.transaction_date)

      true
    end

    private

    def transaction_above_user_limit?
      @transaction.transaction_amount > @user.transaction_amount_limit
    end

    def too_much_transactions_within_timeframe?(transaction_date:)
      number_of_transactions = @user
                               .transactions
                               .number_of_transactions_by_timeframe(
                                 start_time: transaction_date - SUBSEQUENT_TIMEFRAME,
                                 end_time: transaction_date
                               )

      number_of_transactions > MAX_TRANSACTIONS_PER_TIMEFRAME
    end
  end
end
