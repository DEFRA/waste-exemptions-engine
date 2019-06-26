class AddJsonToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :json, :json
  end
end
