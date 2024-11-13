class AddReversalFieldsToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :reversed_by, :string
    add_column :payments, :reversed_at, :datetime
    add_column :payments, :reversal_id, :integer
    add_index :payments, :reversal_id
  end
end
