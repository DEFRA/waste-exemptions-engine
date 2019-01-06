# frozen_string_literal: true

class AddStatusToEnrollmentExemptions < ActiveRecord::Migration
  def change
    add_column :enrollment_exemptions, :state, :string
  end
end
