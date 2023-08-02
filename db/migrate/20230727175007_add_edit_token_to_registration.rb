# frozen_string_literal: true

class AddEditTokenToRegistration < ActiveRecord::Migration[7.0]
  def up
    add_column :registrations, :edit_token, :string
    add_column :registrations, :edit_token_created_at, :datetime
    add_index :registrations, :edit_token, unique: true
  end

  def down
    remove_column :registrations, :edit_token
    remove_column :registrations, :edit_token_created_at
  end
end
