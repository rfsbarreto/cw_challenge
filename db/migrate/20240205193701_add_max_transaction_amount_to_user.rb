class AddMaxTransactionAmountToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :max_transaction_amount, :decimal
  end
end
