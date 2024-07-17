# frozen_string_literal: true

class AddOrderableIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :orderable, polymorphic: true, index: true
  end
end
