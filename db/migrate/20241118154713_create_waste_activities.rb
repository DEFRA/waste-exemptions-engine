# frozen_string_literal: true

class CreateWasteActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :waste_activities do |t|
      t.string :name
      t.integer :category

      t.timestamps
    end
  end
end
