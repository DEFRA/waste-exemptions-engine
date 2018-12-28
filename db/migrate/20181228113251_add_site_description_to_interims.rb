# frozen_string_literal: true

class AddSiteDescriptionToInterims < ActiveRecord::Migration
  def change
    add_column :interims, :site_description, :string
  end
end
