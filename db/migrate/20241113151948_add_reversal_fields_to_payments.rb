# frozen_string_literal: true

class AddReversalFieldsToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :created_by, :string
    add_column :payments, :associated_payment_id, :integer
    add_index :payments, :associated_payment_id
  end
end
