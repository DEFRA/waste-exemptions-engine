# frozen_string_literal: true

class AddApplicantPhoneToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :applicant_phone, :string
  end
end
