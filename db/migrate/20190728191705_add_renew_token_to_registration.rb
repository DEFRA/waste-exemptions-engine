class AddRenewTokenToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :renew_token, :string
    add_index :registrations, :renew_token, unique: true
  end
end
