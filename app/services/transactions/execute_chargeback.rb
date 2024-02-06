module Transactions
  class ExecuteChargeback
    def initialize(transaction_id:, chargebacked:)
      @transaction_id = transaction_id
      @chargebacked = chargebacked
      @errors = []
    end

    def run
      ActiveRecord::Base.transaction do
        transaction = Transaction.find(@transaction_id)

        transaction.update(chargebacked: @chargebacked)
        update_user_block_transactions(user: transaction.user, should_block: @chargebacked)
        increment_merchant_chargebacks(merchant: transaction.merchant)
      end

      true
    rescue StandardError
      false
    end

    private

    def update_user_block_transactions(user:, should_block:)
      user.update!(block_transactions: should_block)
    end

    def increment_merchant_chargebacks(merchant:)
      merchant.number_chargebacks += 1
      merchant.save!
    end
  end
end
