# frozen_string_literal: true

class CreateExemptions < ActiveRecord::Migration[4.2]
  def change
    create_table :exemptions do |t|
      t.integer :category
      t.string :code
      t.string :url
      t.string :summary
      t.text :description
      t.text :guidance
    end
  end
end
