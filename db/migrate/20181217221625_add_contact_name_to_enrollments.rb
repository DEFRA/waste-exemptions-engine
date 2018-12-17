# frozen_string_literal: true

class AddContactNameToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :contact_first_name, :string
    add_column :enrollments, :contact_last_name, :string
  end
end
