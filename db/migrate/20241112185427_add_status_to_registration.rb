# frozen_string_literal: true

class AddStatusToRegistration < ActiveRecord::Migration[7.1]
  def change
    add_column :registrations, :lifecycle_status, :string
    add_index :registrations, :lifecycle_status
  end
end
