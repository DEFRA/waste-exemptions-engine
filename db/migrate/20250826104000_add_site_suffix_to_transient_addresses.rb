# frozen_string_literal: true

class AddSiteSuffixToTransientAddresses < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    add_column :transient_addresses, :site_suffix, :string
    add_index :transient_addresses, %i[transient_registration_id address_type site_suffix],
              name: "index_transient_addresses_on_registration_type_suffix",
              algorithm: :concurrently
  end
end
