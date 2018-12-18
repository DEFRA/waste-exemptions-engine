# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :address_type, default: 0
      t.string :uprn
      t.string :organisation
      t.string :premises
      t.string :street_address
      t.string :locality
      t.string :city
      t.string :postcode
      t.float :x
      t.float :y
      t.string :coordinate_system
      t.string :blpu_state_code
      t.string :postal_address_code
      t.string :logical_status_code
      t.string :source_data_type
      t.string :country_iso
      t.belongs_to :enrollment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
