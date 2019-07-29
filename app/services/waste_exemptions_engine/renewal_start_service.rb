# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalStartService < BaseService
    def run
      RenewingRegistration.create
    end
  end
end
