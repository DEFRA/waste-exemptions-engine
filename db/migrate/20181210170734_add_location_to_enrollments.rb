# frozen_string_literal: true

class AddLocationToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :location, :string
  end
end
