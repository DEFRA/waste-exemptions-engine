# frozen_string_literal: true

class AddOperatorNameToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :operator_name, :string
  end
end
