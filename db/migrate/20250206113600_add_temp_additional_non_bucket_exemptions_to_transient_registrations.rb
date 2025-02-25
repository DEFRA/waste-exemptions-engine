# frozen_string_literal: true

class AddTempAdditionalNonBucketExemptionsToTransientRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :transient_registrations, :temp_add_additional_non_bucket_exemptions, :boolean
  end
end
