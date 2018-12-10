# frozen_string_literal: true

class AddApplicantNameToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :applicant_first_name, :string
    add_column :enrollments, :applicant_last_name, :string
  end
end
