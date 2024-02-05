class TransactionsController < ApplicationController
  def create
    transaction_params
    transaction = Transaction.new(transaction_params)

    if transaction.valid?
      ActiveRecord::Base.transaction do
        user = User.find_or_create_by!(id: transaction[:user_id])
        merchant = Merchant.find_or_create_by!(id: transaction[:merchant_id])

        fraud_check = Transactions::FraudCheck.new(transaction:, user:, merchant:)

        transaction.approved = fraud_check.transaction_cleared?
                               
        transaction.save!
      end
      render json: { transaction_id: transaction.id, recommendation: transaction.recommendation }, status: :created
    else
      render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def transaction_params
    transaction = params
                  .permit(:transaction_id,
                          :merchant_id,
                          :user_id,
                          :card_number,
                          :transaction_date,
                          :transaction_amount,
                          :device_id)
    transaction[:id] = transaction.delete(:transaction_id)

    transaction
  end
end
