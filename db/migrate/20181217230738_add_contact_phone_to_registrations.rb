# frozen_string_literal: true

class AddContactPhoneToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :contact_phone, :string
  end
end
