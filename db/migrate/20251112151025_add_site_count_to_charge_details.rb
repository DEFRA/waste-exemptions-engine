# frozen_string_literal: true

class AddSiteCountToChargeDetails < ActiveRecord::Migration[7.2]
  def change
    add_column :charge_details, :site_count, :integer, default: 1
  end
end
