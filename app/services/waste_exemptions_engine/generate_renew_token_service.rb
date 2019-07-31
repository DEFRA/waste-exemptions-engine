# frozen_string_literal: true

require_relative "concerns/can_process_jwt_tokens"

module WasteExemptionsEngine
  class GenerateRenewTokenService < BaseService
    include CanProcessJwtTokens

    def run(registration:)
      payload = {
        data: {
          registration_id: registration.id
        },
        exp: exp
      }

      registration.renew_token = generate_token(payload)

      registration.save!
    end

    private

    def exp
      Time.now.to_i + days_until_expire * 24 * 3600
    end

    def days_until_expire
      registration_renewal_grace_window + first_renewal_email_reminder_days
    end

    def registration_renewal_grace_window
      Rails.application.config.registration_renewal_grace_window.to_i
    end

    def first_renewal_email_reminder_days
      Rails.application.config.first_renewal_email_reminder_days.to_i
    end
  end
end
