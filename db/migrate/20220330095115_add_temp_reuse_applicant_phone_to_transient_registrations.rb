# frozen_string_literal: true

class AddTempReuseApplicantPhoneToTransientRegistrations < ActiveRecord::Migration[6.1]
  def change
    add_column :transient_registrations, :temp_reuse_applicant_phone, :boolean, default: nil
  end
end
