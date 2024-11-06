class AddAccountIdToPayments < ActiveRecord::Migration[7.1]
  def change
    add_reference :payments, :account, foreign_key: true
  end
end
