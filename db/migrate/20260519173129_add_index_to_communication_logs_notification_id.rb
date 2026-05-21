# frozen_string_literal: true

class AddIndexToCommunicationLogsNotificationId < ActiveRecord::Migration[7.2]
  def change
    add_index :communication_logs, :notification_id
  end
end
