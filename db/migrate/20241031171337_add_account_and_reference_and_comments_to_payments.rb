# frozen_string_literal: true

class AddAccountAndReferenceAndCommentsToPayments < ActiveRecord::Migration[7.1]
  def change
    add_reference :payments, :account
    add_column :payments, :reference, :string
    add_column :payments, :comments, :string, limit: 500
  end
end
