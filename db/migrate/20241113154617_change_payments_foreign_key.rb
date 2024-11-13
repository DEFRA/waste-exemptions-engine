# frozen_string_literal: true

class ChangePaymentsForeignKey < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :payments, :orders
    add_foreign_key :payments, :accounts
  end
end
