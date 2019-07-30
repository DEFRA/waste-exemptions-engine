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
      # Expires in 60 days
      Time.now.to_i + 60 * 24 * 3600
    end

    def renew_token_expires_in_days
      Rails.application.config.renew_token_expires_in_days
    end
  end
end
