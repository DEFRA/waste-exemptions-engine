class AddApplicantEmailToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :applicant_email, :string
  end
end
