# frozen_string_literal: true

class AddDateFieldsToEnrollmentExemptions < ActiveRecord::Migration
  def change
    add_column :enrollment_exemptions, :registered_on, :date
    add_column :enrollment_exemptions, :expires_on, :date
  end
end
