# frozen_string_literal: true

class AddSiteSuffixToAddresses < ActiveRecord::Migration[7.2]
  def change
    add_column :addresses, :site_suffix, :string
  end
end
