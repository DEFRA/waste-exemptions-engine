# frozen_string_literal: true

class AddTempUseRegisteredCompanyDetailsToTransientRegistrations < ActiveRecord::Migration[6.1]
  def change
    add_column :transient_registrations, :temp_use_registered_company_details, :boolean, default: nil
  end
end
