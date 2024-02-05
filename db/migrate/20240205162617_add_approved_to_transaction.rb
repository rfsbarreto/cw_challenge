class AddApprovedToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :approved, :boolean, null: false
  end
end
