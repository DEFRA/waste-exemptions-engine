# frozen_string_literal: true

class AddTokenToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :token, :string
    add_index :registrations, :token, unique: true
  end
end
