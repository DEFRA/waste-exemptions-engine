# frozen_string_literal: true

class CreateInterims < ActiveRecord::Migration
  def change
    create_table :interims do |t|
      t.string :operator_postcode
      t.string :contact_postcode
      t.string :site_postcode
      t.string :grid_reference
      t.text :site_description
      t.boolean :address_finder_error, default: false
      t.belongs_to :registration, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
