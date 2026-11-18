# frozen_string_literal: true

class AddTemplateIndexesToCommunicationLogs < ActiveRecord::Migration[8.1]
  def change
    add_index :communication_logs, :template_id
    add_index :communication_logs, :template_label
  end
end
