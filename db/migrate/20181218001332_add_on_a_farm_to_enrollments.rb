# frozen_string_literal: true

class AddOnAFarmToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :on_a_farm, :boolean
  end
end
