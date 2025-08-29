# frozen_string_literal: true

class AddTransientAddressIdToTransientRegistrationExemptions < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    add_reference :transient_registration_exemptions, :transient_address,
                  null: true,
                  index: {
                    algorithm: :concurrently,
                    name: "index_transient_registration_exemptions_on_transient_address_id"
                  },
                  foreign_key: { to_table: :transient_addresses, validate: false }
  end
end
