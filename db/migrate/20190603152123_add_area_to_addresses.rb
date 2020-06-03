# frozen_string_literal: true

class AddAreaToAddresses < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :area, :string
  end
end
