# frozen_string_literal: true

class AddIsAFarmToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :is_a_farm, :boolean
  end
end
