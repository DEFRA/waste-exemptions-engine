# frozen_string_literal: true

class AddLocationToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :location, :string
  end
end
