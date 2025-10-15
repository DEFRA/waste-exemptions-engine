# frozen_string_literal: true

module WasteExemptionsEngine
  class AssignSiteSuffixService < BaseService
    attr_reader :address

    def run(address:)
      @address = address

      assign_suffix
    end

    private

    def registration
      address.try(:transient_registration) || address.try(:registration)
    end

    def assign_suffix
      return unless registration.present?

      next_number = registration.site_addresses.count + 1
      address.site_suffix = format("%05d", next_number)
    end
  end
end
