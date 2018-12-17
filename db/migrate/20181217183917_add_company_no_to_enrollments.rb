# frozen_string_literal: true

class AddCompanyNoToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :company_no, :string
  end
end
