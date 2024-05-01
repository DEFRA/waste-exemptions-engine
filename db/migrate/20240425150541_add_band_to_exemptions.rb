# frozen_string_literal: true

class AddBandToExemptions < ActiveRecord::Migration[7.1]
  def change
    add_reference :exemptions, :band, index: true, foreign_key: true
  end
end
