# frozen_string_literal: true

class ChangeSiteDescriptionToBeTextInInterims < ActiveRecord::Migration
  def change
    reversible do |change|
      change.up { change_column :interims, :site_description, :text }
      change.down { change_column :interims, :site_description, :string }
    end
  end
end
