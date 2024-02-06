module Transactions
  class ExecuteChargeback
    def initialize(transaction_id:)
      @transaction_id = transaction_id
    end

    def run
      ActiveRecord::Base.transaction do
        transaction = Transaction.find(@transaction_id)

        transaction.update(chargebacked: true)
        update_user_block_transactions(user: transaction.user)
        increment_merchant_chargebacks(merchant: transaction.merchant)
      end

      true
    rescue StandardError
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
