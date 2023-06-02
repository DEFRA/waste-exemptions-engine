# frozen_string_literal: true

class AddTempReuseOperatorAddressToTransientRegistrations < ActiveRecord::Migration[6.1]
  def change
    add_column :transient_registrations, :temp_reuse_operator_address, :boolean, default: nil
  end
end
