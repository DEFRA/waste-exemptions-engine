# frozen_string_literal: true

class AddSiteSuffixToAddresses < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    add_column :addresses, :site_suffix, :string
    add_index :addresses, %i[registration_id address_type site_suffix],
              name: "index_addresses_on_registration_type_suffix",
              algorithm: :concurrently
  end
end
