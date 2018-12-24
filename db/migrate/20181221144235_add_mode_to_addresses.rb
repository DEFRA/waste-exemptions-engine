# frozen_string_literal: true

class AddModeToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :mode, :integer, default: 0
  end
end
