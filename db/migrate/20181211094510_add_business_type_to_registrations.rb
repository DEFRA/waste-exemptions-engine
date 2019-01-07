# frozen_string_literal: true

class AddBusinessTypeToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :business_type, :string
  end
end
