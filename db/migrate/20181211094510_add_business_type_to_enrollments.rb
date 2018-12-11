# frozen_string_literal: true

class AddBusinessTypeToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :business_type, :string
  end
end
