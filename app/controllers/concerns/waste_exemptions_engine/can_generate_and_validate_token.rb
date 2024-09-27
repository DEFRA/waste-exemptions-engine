# frozen_string_literal: true

module WasteExemptionsEngine
  module CanGenerateAndValidateToken
    extend ActiveSupport::Concern

    def generate_token(field, timestamp_field)
      send("#{field}=", SecureRandom.uuid)
      send("#{timestamp_field}=", Time.zone.now)
      save!

      send(field)
    end

    def token_valid?(field, timestamp_field, validity_period)
      token = self[field]
      timestamp = self[timestamp_field]
      return false unless token.present? && timestamp.present?

      timestamp + validity_period.days >= Time.zone.now
    end
  end
end
