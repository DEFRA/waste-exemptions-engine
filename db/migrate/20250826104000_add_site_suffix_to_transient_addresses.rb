# frozen_string_literal: true

class AddSiteSuffixToTransientAddresses < ActiveRecord::Migration[7.2]
  def change
    add_column :transient_addresses, :site_suffix, :string
  end
end
