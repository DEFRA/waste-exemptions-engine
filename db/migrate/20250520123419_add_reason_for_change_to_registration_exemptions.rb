# frozen_string_literal: true

class AddReasonForChangeToRegistrationExemptions < ActiveRecord::Migration[7.2]
  def change
    add_column :registration_exemptions, :reason_for_change, :string, limit: 500
  end
end
