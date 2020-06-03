class RemoveTransientRegistrationsRegerenceIndex < ActiveRecord::Migration[4.2]
  def change
    remove_index "transient_registrations", "reference"
  end
end
