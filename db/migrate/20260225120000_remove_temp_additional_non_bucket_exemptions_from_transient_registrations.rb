# frozen_string_literal: true

class RemoveTempAdditionalNonBucketExemptionsFromTransientRegistrations < ActiveRecord::Migration[7.1]
  def change
    # Guarded because some long-lived schema dumps predate this temp column's
    # existence, so replaying migrations over them would fail otherwise
    return unless column_exists?(:transient_registrations, :temp_add_additional_non_bucket_exemptions)

    remove_column :transient_registrations, :temp_add_additional_non_bucket_exemptions, :boolean
  end
end
