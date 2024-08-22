# frozen_string_literal: true

class AddOrderUuidToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :order_uuid, :string
  end
end
