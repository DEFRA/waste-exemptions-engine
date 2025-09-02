# frozen_string_literal: true

class AddAddressIdToRegistrationExemptions < ActiveRecord::Migration[7.2]
  def change
    add_reference :registration_exemptions, :address,
                  null: true,
                  index: false,
                  foreign_key: { to_table: :addresses, validate: false }
  end
end
