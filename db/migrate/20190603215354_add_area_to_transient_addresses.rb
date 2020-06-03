# frozen_string_literal: true

class AddAreaToTransientAddresses < ActiveRecord::Migration[4.2]
  def change
    add_column :transient_addresses, :area, :string
  end
end
