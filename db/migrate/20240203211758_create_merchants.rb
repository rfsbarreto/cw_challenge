class CreateMerchants < ActiveRecord::Migration[7.0]
  def change
    create_table :merchants do |t|
      t.integer :number_transactions, null: false, default: 0
      t.boolean :block_transactions, null: false, default: false
      t.integer :number_chargebacks, null: false, default: 0
      t.decimal :total_value, null: false, default: 0.0

      t.timestamps
    end
  end
end
