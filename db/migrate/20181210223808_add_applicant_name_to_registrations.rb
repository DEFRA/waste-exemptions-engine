# frozen_string_literal: true

class AddApplicantNameToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :applicant_first_name, :string
    add_column :registrations, :applicant_last_name, :string
  end
end
