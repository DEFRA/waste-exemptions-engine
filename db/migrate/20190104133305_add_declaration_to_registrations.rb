# frozen_string_literal: true

class AddDeclarationToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :declaration, :boolean
  end
end
