# frozen_string_literal: true

class AddDeregistrationFieldsToTransientRegistrationExemptions < ActiveRecord::Migration[7.2]
  def change
    add_column :transient_registration_exemptions, :deregistered_at, :date
    add_column :transient_registration_exemptions, :deregistration_message, :text
    add_column :transient_registration_exemptions, :reason_for_change, :string, limit: 500
  end
end
