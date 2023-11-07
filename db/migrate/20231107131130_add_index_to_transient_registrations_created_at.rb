# frozen_string_literal: true

class AddIndexToTransientRegistrationsCreatedAt < ActiveRecord::Migration[7.0]
  def change
    add_index :transient_registrations, :created_at
  end
end
