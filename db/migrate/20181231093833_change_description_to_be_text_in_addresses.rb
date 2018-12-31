# frozen_string_literal: true

class ChangeDescriptionToBeTextInAddresses < ActiveRecord::Migration
  def change
    reversible do |change|
      change.up { change_column :addresses, :description, :text }
      change.down { change_column :addresses, :description, :string }
    end
  end
end
