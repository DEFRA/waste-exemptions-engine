# frozen_string_literal: true

class AddDeregistrationFieldsToTransientRegistrationExemptions < ActiveRecord::Migration[7.2]
  def change
    add_column :transient_registration_exemptions, :deregistered_at, :date
    add_column :transient_registration_exemptions, :deregistration_message, :text
  end
end
