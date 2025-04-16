# frozen_string_literal: true

class AddEditLinkRequestedByToRegistrations < ActiveRecord::Migration[7.2]
  def change
    add_column :registrations, :edit_link_requested_by, :string
  end
end
