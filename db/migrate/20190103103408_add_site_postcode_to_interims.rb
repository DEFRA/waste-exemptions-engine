# frozen_string_literal: true

class AddSitePostcodeToInterims < ActiveRecord::Migration
  def change
    add_column :interims, :site_postcode, :string
  end
end
