# frozen_string_literal: true

class AddCompanyNoToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :company_no, :string
  end
end
