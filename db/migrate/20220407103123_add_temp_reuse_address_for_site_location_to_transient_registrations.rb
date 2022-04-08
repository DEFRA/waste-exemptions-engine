class AddTempReuseAddressForSiteLocationToTransientRegistrations < ActiveRecord::Migration[6.1]
  def change
    add_column :transient_registrations, :temp_reuse_address_for_site_location, :string, default: nil
  end
end
