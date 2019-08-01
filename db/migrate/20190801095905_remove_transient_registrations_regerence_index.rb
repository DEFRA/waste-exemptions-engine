class RemoveTransientRegistrationsRegerenceIndex < ActiveRecord::Migration
  def change
    remove_index "transient_registrations", "reference"
  end
end
