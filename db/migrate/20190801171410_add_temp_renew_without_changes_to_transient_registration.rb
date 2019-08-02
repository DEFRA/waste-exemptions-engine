class AddTempRenewWithoutChangesToTransientRegistration < ActiveRecord::Migration
  def change
    add_column :transient_registrations, :temp_renew_without_changes, :boolean
  end
end
