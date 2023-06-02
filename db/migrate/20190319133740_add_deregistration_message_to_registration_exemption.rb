# frozen_string_literal: true

class AddDeregistrationMessageToRegistrationExemption < ActiveRecord::Migration[4.2]
  def change
    add_column :registration_exemptions, :deregistration_message, :text
  end
end
