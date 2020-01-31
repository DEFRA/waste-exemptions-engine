# frozen_string_literal: true

module WasteExemptionsEngine
  class AddressLookupService < BaseService
    def run(postcode)
      DefraRuby::Address::EaAddressFacadeV1Service.run(postcode)
    end
  end
end
