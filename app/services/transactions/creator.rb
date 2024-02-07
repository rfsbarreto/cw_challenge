# frozen_string_literal: true

module Transactions
  # The Creator Service class is responsible for creating transactions and related records
  # please note that another service(Transactions::CheckFraud) is triggered during execution for fill approved attribute
  class Creator
    # @!attribute [r] errors
    #   @return [String] returns errors found during execution of Service
    attr_reader :errors

    # @!attribute [r] transaction
    #   @return Transaction returns the persisted transaction
    attr_reader :transaction

    # Initialize a new Creator instance with transaction params
    #
    # @param transaction_params [Hash] The parameters for the transaction
    def initialize(transaction_params:)
      @transaction = Transaction.new(transaction_params)
    end

    # Run the transaction creation process
    #
    # @return [Boolean] true if the transaction was successfully created, false otherwise
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

    # Check if the transaction is cleared of fraud
    #
    # @param transaction [Transaction] The transaction to be checked
    # @param user [User] The user associated with the transaction
    # @param merchant [Merchant] The merchant associated with the transaction
    # @return [Boolean] true if the transaction is cleared, false otherwise
    def approve_transaction?(transaction:, user:, merchant:)
      check_for_fraud = Transactions::CheckFraud.new(transaction:, user:, merchant:)

      check_for_fraud.transaction_cleared?
    end
  end
end
