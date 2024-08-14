# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|

      t.references :registration, null: false, foreign_key: true
      t.integer :balance, null: false, default: 0
      t.timestamps
    end
  end
end
