class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :card_number, null: false
      t.datetime :transaction_date, null: false
      t.decimal :transaction_amount, null: false
      t.integer :device_id, null: true
      t.references :user, null: false
      t.references :merchant, null: false

      t.timestamps
    end
  end
end
