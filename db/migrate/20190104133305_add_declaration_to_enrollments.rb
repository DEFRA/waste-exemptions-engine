# frozen_string_literal: true

class AddDeclarationToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :declaration, :boolean
  end
end
