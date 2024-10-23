# frozen_string_literal: true

class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :company_no, null: false
      t.boolean :active

      t.index :company_no, unique: true
      t.timestamps
    end
  end
end
