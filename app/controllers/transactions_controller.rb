# frozen_string_literal: true

class TransactionsController < ApplicationController
  def create
    creator = Transactions::Creator.new(transaction_params:)

    if creator.run
      transaction = creator.transaction
      render json: { transaction_id: transaction.id, recommendation: transaction.recommendation }, status: :created
    else
      render json: { errors: creator.errors }, status: :unprocessable_entity
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
