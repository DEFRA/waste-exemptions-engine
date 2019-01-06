# frozen_string_literal: true

class AddReferenceToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :reference, :string
  end
end
