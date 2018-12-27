# frozen_string_literal: true

class AddContactPostcodeToInterims < ActiveRecord::Migration
  def change
    add_column :interims, :contact_postcode, :string
  end
end
