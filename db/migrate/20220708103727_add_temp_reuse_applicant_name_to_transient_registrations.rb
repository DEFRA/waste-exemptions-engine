class AddTempReuseApplicantNameToTransientRegistrations < ActiveRecord::Migration[6.1]
  def change
    add_column :transient_registrations, :temp_reuse_applicant_name, :boolean, default: nil
  end
end
