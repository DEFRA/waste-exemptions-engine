# frozen_string_literal: true

class AddIndexRegistrationExemptionsOnAddressId < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    add_index :registration_exemptions, :address_id,
              name: "index_registration_exemptions_on_address_id",
              algorithm: :concurrently
  end
end
