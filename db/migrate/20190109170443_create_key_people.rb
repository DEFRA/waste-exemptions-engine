# frozen_string_literal: true

class CreateKeyPeople < ActiveRecord::Migration
  def change
    create_table :key_people do |t|
      t.string :first_name
      t.string :last_name
      t.integer :person_type
      t.belongs_to :registration, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
