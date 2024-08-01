# frozen_string_literal: true

class AddReceiptEmailToRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :registrations, :receipt_email, :string
    add_column :transient_registrations, :receipt_email, :string
  end
end
