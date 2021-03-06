# frozen_string_literal: true

class AddTypeToTransientRegistrations < ActiveRecord::Migration[4.2]
  def up
    add_column :transient_registrations, :type, :string, null: false
    # Set any existing TransientRegistrations to NewRegistrations so everything has a type
    execute <<-SQL
       UPDATE transient_registrations
       SET type = 'WasteExemptionsEngine::NewRegistration';
    SQL
  end

  def down
    remove_column :transient_registrations, :type
  end
end
