# frozen_string_literal: true

module WasteExemptionsEngine
  class CopyExemptionsService < BaseService
    def run(transient_registration:, registration:, address_mapping:)
      transient_registration.transient_registration_exemptions.each do |transient_exemption|
        if transient_exemption.transient_address_id.present?
          # Renewal: exemptions already have site association, map 1:1
          new_address = address_mapping[transient_exemption.transient_address_id]
          registration.registration_exemptions << RegistrationExemption.new(
            transient_exemption.exemption_attributes.merge(address: new_address)
          )
        else
          # New registration: duplicate exemption to each site
          registration.addresses.select(&:site?).each do |site_address|
            registration.registration_exemptions << RegistrationExemption.new(
              transient_exemption.exemption_attributes.merge(address: site_address)
            )
          end
        end
      end
    end
  end
end
