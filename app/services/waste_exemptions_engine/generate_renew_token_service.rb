# frozen_string_literal: true

module WasteExemptionsEngine
  class GenerateRenewTokenService < BaseService
    def run(registration:)
      registration.regenerate_renew_token

      registration.save!
    end
  end
end
