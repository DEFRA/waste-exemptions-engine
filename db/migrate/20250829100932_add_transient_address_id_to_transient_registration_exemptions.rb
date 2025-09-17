# frozen_string_literal: true

class AddTransientAddressIdToTransientRegistrationExemptions < ActiveRecord::Migration[7.2]
  def change
    add_reference :transient_registration_exemptions, :transient_address,
                  null: true,
                  index: false,
                  foreign_key: { to_table: :transient_addresses, validate: false }
  end
end
