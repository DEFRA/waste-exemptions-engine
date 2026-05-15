# frozen_string_literal: true

class AddContentFieldsToCommunicationLogs < ActiveRecord::Migration[7.2]
  def change
    change_table :communication_logs, bulk: true do |t|
      t.string :notification_id
      t.string :subject
      t.text :body
      t.string :status, default: "sent"
    end
  end
end
