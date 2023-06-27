# frozen_string_literal: true

class RemoveDeregistrationEmailSentAt < ActiveRecord::Migration[7.0]
  def change
    if WasteExemptionsEngine::Registration.where.not(deregistration_email_sent_at: nil).any?
      abort "Registrations still present with deregistration_email_sent_at, " \
            "Migration RemoveDeregistrationEmailSentAt exiting without changes."
    end

    remove_column :registrations, :deregistration_email_sent_at
  end
end
