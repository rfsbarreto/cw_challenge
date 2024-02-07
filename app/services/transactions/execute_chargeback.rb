module Transactions
  # The ExecuteChargeback Service class is responsible for executing chargebacks on transactions
  class ExecuteChargeback
    attr_reader :errors

    # Initialize a new ExecuteChargeback instance with transaction_id
    #
    # @param transaction_id [Integer] The ID of the transaction to be chargebacked
    def initialize(transaction_id:)
      @transaction_id = transaction_id
    end

    # Execute the chargeback operation for the specified transaction
    #
    # @return [Boolean] true if the chargeback operation was successful, false otherwise
    def run
      transaction = Transaction.find(@transaction_id)

      ActiveRecord::Base.transaction do
        transaction.update(chargebacked: true)
        update_user_block_transactions(user: transaction.user)
        increment_merchant_chargebacks(merchant: transaction.merchant)
      end

      transaction.chargebacked?
    rescue StandardError => e
      Rails.logger.error "Errors trying to execute chargeback transaction: #{e.full_message}"

      @errors = [e.message]
      false
    end

    private

    def update_user_block_transactions(user:)
      user.update!(block_transactions: true)
    end

    def increment_merchant_chargebacks(merchant:)
      merchant.number_chargebacks += 1
      merchant.save!
    end
  end
end
