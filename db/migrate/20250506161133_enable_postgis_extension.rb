# frozen_string_literal: true

class EnablePostgisExtension < ActiveRecord::Migration[7.2]
  def up
    enable_extension "postgis"
  end

  def down
  end
end
