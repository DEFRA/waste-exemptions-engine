# frozen_string_literal: true

module WasteExemptionsEngine
  class CopyExemptionsService < BaseService
    def run(transient_registration_exemptions:, site_address:)
      transient_registration_exemptions.each do |transient_registration_exemption|
        site_address.registration.registration_exemptions << RegistrationExemption.new(
          transient_registration_exemption.exemption_attributes.merge(address: site_address)
        )
      end
    end
  end
end
