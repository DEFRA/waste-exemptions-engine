# frozen_string_literal: true

class CreateWasteExemptionsEngineOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders, &:timestamps
  end
end
