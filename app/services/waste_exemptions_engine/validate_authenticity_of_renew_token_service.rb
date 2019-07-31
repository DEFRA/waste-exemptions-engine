# frozen_string_literal: true

require_relative "concerns/can_process_jwt_tokens"

module WasteExemptionsEngine
  class ValidateAuthenticityOfRenewTokenService < BaseService
    include CanProcessJwtTokens

    def run(token:)
      payload, _header = *decode_token(token)

      return false unless payload["data"] && payload["data"]["registration_id"]

      Registration.find_by(id: payload["data"]["registration_id"])&.renew_token == token
    rescue JWT::ExpiredSignature, JWT::DecodeError
      false
    end
  end
end
