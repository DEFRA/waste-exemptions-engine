# frozen_string_literal: true

class CreateTransientKeyPeople < ActiveRecord::Migration
  def change
    create_table :transient_key_people do |t|
      t.string :first_name
      t.string :last_name
      t.integer :person_type
      t.belongs_to :transient_registration, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
