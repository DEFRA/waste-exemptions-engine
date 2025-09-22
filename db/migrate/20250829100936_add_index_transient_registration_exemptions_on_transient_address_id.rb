# frozen_string_literal: true

class AddIndexTransientRegistrationExemptionsOnTransientAddressId < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    add_index :transient_registration_exemptions, :transient_address_id,
              name: "index_transient_registration_exemptions_on_transient_address_id",
              algorithm: :concurrently
  end
end
