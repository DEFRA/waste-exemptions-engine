class AddReasonToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :reason, :text
  end
end
