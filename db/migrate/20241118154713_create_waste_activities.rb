# frozen_string_literal: true

class CreateWasteActivities < ActiveRecord::Migration[7.1]
  def change
    return if table_exists?(:waste_activities)

    create_table :waste_activities do |t|
      t.string :name
      t.string :name_gerund
      t.integer :category

      t.timestamps
    end
  end
end
