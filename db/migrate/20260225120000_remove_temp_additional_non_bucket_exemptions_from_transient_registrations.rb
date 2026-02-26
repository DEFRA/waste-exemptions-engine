# frozen_string_literal: true

class RemoveTempAdditionalNonBucketExemptionsFromTransientRegistrations < ActiveRecord::Migration[7.1]
  def change
    remove_column :transient_registrations, :temp_add_additional_non_bucket_exemptions, :boolean
  end
end
