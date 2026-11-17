# frozen_string_literal: true

class AddPermitApplicationToRegistrations < ActiveRecord::Migration[8.1]
  def change
    add_column :registrations, :permit_application_number, :string
    add_column :registrations, :permit_application_status, :string
  end
end
