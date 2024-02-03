class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :number_transactions, null: false, default: 0
      t.boolean :block_transactions
      t.float :total_value

      t.timestamps
    end
  end
end
