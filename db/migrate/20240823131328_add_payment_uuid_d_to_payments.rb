# frozen_string_literal: true

class AddPaymentUuidDToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :payment_uuid, :string
  end
end
