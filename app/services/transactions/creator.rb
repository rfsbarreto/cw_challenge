module Transactions
  class Creator
    attr_reader :transaction, :errors

    def initialize(transaction_params:)
      @transaction_params = transaction_params
    end

    def run
      @transaction = Transaction.new(@transaction_params)

      ActiveRecord::Base.transaction do
        user = User.find_or_create_by!(id: @transaction.user_id)

        merchant = Merchant.find_or_create_by!(id: @transaction.merchant_id)

        @transaction.approved = approve_transaction?(transaction: @transaction, user:, merchant:)

        @transaction.save!
      end

      true
    rescue StandardError => e
      Rails.logger.error "Error trying to save transaction #{e.full_message}"

      @errors = e.full_message
      @transaction = nil
      false
    end

    private

    def approve_transaction?(transaction:, user:, merchant:)
      check_for_fraud = Transactions::CheckFraud.new(transaction:, user:, merchant:)

      check_for_fraud.transaction_cleared?
    end
  end
end
