class AddCompaniesHouseUpdatedAtToTransientRegistrations < ActiveRecord::Migration[6.1]
  def change
    add_column :registrations, :companies_house_updated_at, :datetime
  end
end
