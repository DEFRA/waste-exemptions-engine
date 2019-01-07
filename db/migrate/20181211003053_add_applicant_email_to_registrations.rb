# frozen_string_literal: true

class AddApplicantEmailToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :applicant_email, :string
  end
end
