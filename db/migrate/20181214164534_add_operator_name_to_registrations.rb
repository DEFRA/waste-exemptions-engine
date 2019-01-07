# frozen_string_literal: true

class AddOperatorNameToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :operator_name, :string
  end
end
