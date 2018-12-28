# frozen_string_literal: true

class AddDescriptionToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :description, :string
  end
end
