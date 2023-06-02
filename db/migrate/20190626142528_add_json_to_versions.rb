# frozen_string_literal: true

class AddJsonToVersions < ActiveRecord::Migration[4.2]
  def change
    add_column :versions, :json, :json
  end
end
