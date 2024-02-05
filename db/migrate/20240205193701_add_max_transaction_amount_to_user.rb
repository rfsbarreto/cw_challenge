class AddMaxTransactionAmountToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :max_transaction_amount, :float, null: false,
                                                        default: ENV['DEFAULT_MAX_TRANSACTION_AMOUNT'] || 10_000
  end
end
