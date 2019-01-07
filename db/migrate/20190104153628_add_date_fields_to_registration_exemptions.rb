# frozen_string_literal: true

class AddDateFieldsToRegistrationExemptions < ActiveRecord::Migration
  def change
    add_column :registration_exemptions, :registered_on, :date
    add_column :registration_exemptions, :expires_on, :date
  end
end
