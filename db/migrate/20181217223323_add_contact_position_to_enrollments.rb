# frozen_string_literal: true

class AddContactPositionToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :contact_position, :string
  end
end
