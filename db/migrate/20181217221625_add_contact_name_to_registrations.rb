# frozen_string_literal: true

class AddContactNameToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :contact_first_name, :string
    add_column :registrations, :contact_last_name, :string
  end
end
