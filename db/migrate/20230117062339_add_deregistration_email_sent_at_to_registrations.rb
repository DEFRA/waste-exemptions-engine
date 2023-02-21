# frozen_string_literal: true

class AddDeregistrationEmailSentAtToRegistrations < ActiveRecord::Migration[6.1]
  def change
    add_column :registrations, :deregistration_email_sent_at, :datetime
    add_index :registrations, :deregistration_email_sent_at
  end
end
