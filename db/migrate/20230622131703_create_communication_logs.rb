# frozen_string_literal: true

class CreateCommunicationLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :communication_logs do |t|

      t.timestamps

      t.string :message_type
      t.string :template_id
      t.string :template_label
      t.string :sent_to
    end
  end
end
