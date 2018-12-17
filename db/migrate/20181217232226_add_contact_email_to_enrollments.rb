# frozen_string_literal: true

class AddContactEmailToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :contact_email, :string
  end
end
