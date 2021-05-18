# frozen_string_literal: true

module WasteExemptionsEngine
  class AddressLookupService < BaseService
    def run(postcode)
      response = DefraRuby::Address::EaAddressFacadeV11Service.run(postcode)

      Rails.logger.info response.successful?
      Rails.logger.info response.results
      Rails.logger.info response.error

      response
    end
  end
end
