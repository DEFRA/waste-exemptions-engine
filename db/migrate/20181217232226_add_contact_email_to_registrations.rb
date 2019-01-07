# frozen_string_literal: true

class AddContactEmailToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :contact_email, :string
  end
end
