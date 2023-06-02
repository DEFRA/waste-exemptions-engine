# frozen_string_literal: true

class AddRenewTokenToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :renew_token, :string
    add_index :registrations, :renew_token, unique: true
  end
end
