# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteAddressManualForm < BaseForm
    attr_accessor :address_finder_error
    attr_accessor :site_address
    attr_accessor :premises, :street_address, :locality, :postcode, :city

    validates :site_address, "waste_exemptions_engine/manual_address": true

    def initialize(registration)
      super

      self.postcode = transient_registration.temp_site_postcode

      self.site_address = @transient_registration.site_address

      # Check if the user reached this page through an Address finder error.
      # Then wipe the temp attribute as we only need it for routing
      self.address_finder_error = @transient_registration.address_finder_error
      transient_registration.update_attributes(address_finder_error: nil)

      # Prefill the existing address unless the postcode has changed from the existing address's postcode
      prefill_site_address_params if saved_address_still_valid?
    end

    def submit(params)
      permitted_attributes = params.require(:site_address)
      permitted_attributes = permitted_attributes.permit(:locality, :postcode, :city, :premises, :street_address, :mode)

      # Needed for validation
      assign_params(permitted_attributes)

      super(site_address_attributes: permitted_attributes)
    end

    private

    def assign_params(permitted_attributes)
      self.site_address = transient_registration.build_site_address(permitted_attributes)

      prefill_site_address_params
    end

    def saved_address_still_valid?
      return false unless site_address
      return true if postcode.blank?
      return true if postcode == site_address.postcode

      false
    end

    def prefill_site_address_params
      return unless site_address

      self.premises = site_address.premises&.strip
      self.street_address = site_address.street_address&.strip
      self.locality = site_address.locality&.strip
      self.city = site_address.city&.strip
      self.postcode = site_address.postcode&.strip
    end
  end
end
