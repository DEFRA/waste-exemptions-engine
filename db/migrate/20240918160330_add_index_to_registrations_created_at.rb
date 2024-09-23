# frozen_string_literal: true

class AddIndexToRegistrationsCreatedAt < ActiveRecord::Migration[7.0]
  def change
    add_index :registrations, :created_at
  end
end
