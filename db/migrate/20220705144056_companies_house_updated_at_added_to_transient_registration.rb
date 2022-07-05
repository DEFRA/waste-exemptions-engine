class CompaniesHouseUpdatedAtAddedToTransientRegistration < ActiveRecord::Migration[6.1]
  def change
    add_column :transient_registrations, :companies_house_updated_at, :datetime
  end
end
