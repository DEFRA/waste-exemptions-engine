# frozen_string_literal: true

class AddChargedToRegistration < ActiveRecord::Migration[7.1]
  def change
    add_column :registrations, :charged, :boolean, default: false
  end
end
