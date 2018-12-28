# frozen_string_literal: true

class AddGridReferenceToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :grid_reference, :string
  end
end
