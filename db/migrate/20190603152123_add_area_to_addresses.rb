# frozen_string_literal: true

class AddAreaToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :area, :string
  end
end
