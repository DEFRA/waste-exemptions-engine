# frozen_string_literal: true

class AddAddressIdToRegistrationExemptions < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    add_reference :registration_exemptions, :address,
                  null: true,
                  index: { algorithm: :concurrently, name: "index_registration_exemptions_on_address_id" },
                  foreign_key: { to_table: :addresses, validate: false }
  end
end
