class AddTempReuseApplicantEmailToTransientRegistrations < ActiveRecord::Migration[6.1]
  def change
    add_column :transient_registrations, :temp_reuse_applicant_email, :boolean, default: nil
  end
end
