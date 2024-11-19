# frozen_string_literal: true

class AddPlaceholderAttributeToRegistration < ActiveRecord::Migration[7.1]
  def change
    add_column :registrations, :placeholder, :boolean, default: false
    add_index :registrations, :placeholder
  end
end
