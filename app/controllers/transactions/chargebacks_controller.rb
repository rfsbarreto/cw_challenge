class Transactions::ChargebacksController < ApplicationController
  def create
    execute_chargeback = Transactions::ExecuteChargeback.new(chargeback_params)

    if execute_chargeback.run
      head :created
    else
      head :unprocessable_entity
    end
  end

  private

  def chargeback_params
    params.permit(:transaction_id, :chargeback_status)
  end
end
