# frozen_string_literal: true

class AddStartOptionToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :start_option, :string
  end
end
