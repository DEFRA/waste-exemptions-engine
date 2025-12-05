# frozen_string_literal: true

class AddDeregisteredByToRegistrationExemptions < ActiveRecord::Migration[7.2]
  def change
    add_column :registration_exemptions, :deregistered_by, :string
    add_column :transient_registration_exemptions, :deregistered_by, :string
  end
end
