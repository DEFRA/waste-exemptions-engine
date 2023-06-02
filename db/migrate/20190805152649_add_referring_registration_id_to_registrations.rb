# frozen_string_literal: true

class AddReferringRegistrationIdToRegistrations < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :referring_registration_id, :integer, index: true
  end
end
