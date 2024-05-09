# frozen_string_literal: true

class CreateWasteExemptionsEngineBands < ActiveRecord::Migration[7.1]
  def change
    create_table :bands do |t|
      t.string :name, null: false
      t.integer :sequence

      t.timestamps
    end
  end
end
