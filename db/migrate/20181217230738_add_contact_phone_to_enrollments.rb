# frozen_string_literal: true

class AddContactPhoneToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :contact_phone, :string
  end
end
