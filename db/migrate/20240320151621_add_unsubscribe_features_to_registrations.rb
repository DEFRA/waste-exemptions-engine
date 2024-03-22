# frozen_string_literal: true

class AddUnsubscribeFeaturesToRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_column :registrations, :reminder_opt_in, :boolean, default: true
    add_column :registrations, :unsubscribe_token, :string
    add_index :registrations, :unsubscribe_token, unique: true
  end
end
