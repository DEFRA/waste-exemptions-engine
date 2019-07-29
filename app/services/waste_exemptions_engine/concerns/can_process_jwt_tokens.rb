# frozen_string_literal: true

require "jwt"

module WasteExemptionsEngine
  module CanProcessJwtTokens
    extend ActiveSupport::Concern

    included do
      def generate_token(payload)
        JWT.encode(payload, signature, algorithm)
      end

      def decode_token(token)
        JWT.decode(token, signature, true, algorithm: algorithm)
      end

      def signature
        # TODO: Decide on a more secure algorithm and fix me
        Rails.application.secrets.secret_key_base
      end

      def algorithm
        # TODO: Decide on a more secure algorithm and fix me
        "HS256"
      end
    end
  end
end
