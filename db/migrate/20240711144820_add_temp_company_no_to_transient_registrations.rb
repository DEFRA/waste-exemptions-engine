# frozen_string_literal: true

class AddTempCompanyNoToTransientRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :transient_registrations, :temp_company_no, :string
  end
end
