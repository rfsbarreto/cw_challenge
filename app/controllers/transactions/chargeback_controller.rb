# frozen_string_literal: true

module Transactions
  class ChargebackController < ApplicationController
    def create
      execute_chargeback = Transactions::ExecuteChargeback.new(transaction_id: params[:id])

      if execute_chargeback.run
        head :created
      else
        head :unprocessable_entity
      end
    end

    private

    def chargeback_params
      params.permit(:transaction_id)
    end
  end
end
