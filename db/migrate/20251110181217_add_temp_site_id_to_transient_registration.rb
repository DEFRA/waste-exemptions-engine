# frozen_string_literal: true

class AddTempSiteIdToTransientRegistration < ActiveRecord::Migration[7.2]
  def change
    add_column :transient_registrations, :temp_site_id, :integer
  end
end
