# frozen_string_literal: true

class AddAreaToTransientAddresses < ActiveRecord::Migration
  def change
    add_column :transient_addresses, :area, :string
  end
end
