# frozen_string_literal: true

class AddApplicantPhoneToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :applicant_phone, :string
  end
end
