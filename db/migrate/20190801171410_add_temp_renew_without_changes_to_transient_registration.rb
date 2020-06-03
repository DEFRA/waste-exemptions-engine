class AddTempRenewWithoutChangesToTransientRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :transient_registrations, :temp_renew_without_changes, :boolean
  end
end
