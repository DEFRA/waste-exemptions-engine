# frozen_string_literal: true

module WasteExemptionsEngine
  class CopyExemptionsService < BaseService
    def run(transient_registration:, registration:)
      @transient_registration = transient_registration
      @registration = registration

        copy_exemptions
    end

    private

    attr_reader :transient_registration, :registration

    def copy_exemptions
      transient_registration.transient_registration_exemptions.each do |transient_registration_exemption|
        if transient_registration.multisite?
          copy_exemptions_for_multisite(registration, transient_registration_exemption)
        else
          copy_exemptions_for_single_site(registration, transient_registration_exemption)
        end
      end
    end

    def copy_exemptions_for_single_site(registration, transient_registration_exemption)
      registration.registration_exemptions << RegistrationExemption.new(
        transient_registration_exemption.exemption_attributes.merge(address: registration.site_address)
      )
    end

    def copy_exemptions_for_multisite(registration, transient_registration_exemption)
      registration.addresses.select(&:site?).each do |site_address|
        registration.registration_exemptions << RegistrationExemption.new(
          transient_registration_exemption.exemption_attributes.merge(address: site_address)
        )
      end
    end
  end
end
