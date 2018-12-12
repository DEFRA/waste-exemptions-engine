# frozen_string_literal: true

class AddTokenToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :token, :string
    add_index :enrollments, :token, unique: true
  end
end
