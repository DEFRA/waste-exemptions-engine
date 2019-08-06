class AddReferringRegistrationIdToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :referring_registration_id, :integer, index: true
  end
end
