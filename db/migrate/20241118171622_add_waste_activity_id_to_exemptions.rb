# frozen_string_literal: true

class AddWasteActivityIdToExemptions < ActiveRecord::Migration[7.1]
  def change
    add_reference :exemptions, :waste_activity
  end
end
