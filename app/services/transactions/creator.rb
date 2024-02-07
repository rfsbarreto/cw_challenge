# frozen_string_literal: true

module Transactions
  class Creator
    attr_reader :transaction, :errors

    def initialize(transaction_params:)
      @transaction = Transaction.new(transaction_params)
    end

    def run
      ActiveRecord::Base.transaction do
        user = create_user_and_increment_transactions!
        merchant = create_merchant_and_increment_transactions!

        save_transaction!(user:, merchant:)
      end

      @transaction.present?
    rescue StandardError => e
      Rails.logger.error "Errors trying to save transaction: #{e.full_message}"

      @transaction = nil
      false
    end

    private

    def save_transaction!(user:, merchant:)
      if @transaction.valid?
        @transaction.approved = approve_transaction?(transaction: @transaction, user:, merchant:)

        @transaction.save!
      else
        @errors = @transaction.errors.full_messages
        @transaction = nil

        raise ActiveRecord::Rollback, @errors.join(';')
      end
    end

    def create_user_and_increment_transactions!
      user = User.find_or_create_by!(id: @transaction.user_id)
      user.increment!(:number_transactions)

      user
    end

    def create_merchant_and_increment_transactions!
      merchant = Merchant.find_or_create_by!(id: @transaction.merchant_id)
      merchant.increment!(:number_transactions)

      merchant
    end

    def approve_transaction?(transaction:, user:, merchant:)
      check_for_fraud = Transactions::CheckFraud.new(transaction:, user:, merchant:)

      check_for_fraud.transaction_cleared?
    end
  end
end
