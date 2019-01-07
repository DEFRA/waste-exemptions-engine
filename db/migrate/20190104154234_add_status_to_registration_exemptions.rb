# frozen_string_literal: true

class AddStatusToRegistrationExemptions < ActiveRecord::Migration
  def change
    add_column :registration_exemptions, :state, :string
  end
end
