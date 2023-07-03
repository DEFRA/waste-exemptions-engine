# frozen_string_literal: true

class AddHiddenFieldToExemptions < ActiveRecord::Migration[7.0]
  def up
    add_column :exemptions, :hidden, :boolean, default: false
    WasteExemptionsEngine::Exemption.find { |e| e.code == "T27" }&.update(hidden: true)
  end

  def down
    remove_column :exemptions, :hidden
  end
end
