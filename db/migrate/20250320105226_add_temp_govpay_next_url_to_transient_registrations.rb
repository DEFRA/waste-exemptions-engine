class AddTempGovpayNextUrlToTransientRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :transient_registrations, :temp_govpay_next_url, :string
  end
end
