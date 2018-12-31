# frozen_string_literal: true

class AddGridReferenceToInterims < ActiveRecord::Migration
  def change
    add_column :interims, :grid_reference, :string
  end
end
