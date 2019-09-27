# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactAddressManualForm < BaseForm
    attr_accessor :address_finder_error
    attr_accessor :contact_address
    attr_accessor :premises, :street_address, :locality, :postcode, :city

    validates :contact_address, "waste_exemptions_engine/manual_address": true

    def initialize(registration)
      super

      self.postcode = transient_registration.temp_contact_postcode

      self.contact_address = transient_registration.contact_address

      # Check if the user reached this page through an Address finder error.
      # Then wipe the temp attribute as we only need it for routing
      self.address_finder_error = transient_registration.address_finder_error
      transient_registration.update_attributes(address_finder_error: nil)

      # Prefill the existing address unless the postcode has changed from the existing address's postcode
      prefill_contact_address_params if saved_address_still_valid?
    end

    def submit(params)
      permitted_attributes = params.require(:contact_address)
      permitted_attributes = permitted_attributes.permit(:locality, :postcode, :city, :premises, :street_address, :mode)

      # Needed for validation
      assign_params(permitted_attributes)

      super(contact_address_attributes: permitted_attributes)
    end

    private

    def assign_params(permitted_attributes)
      self.contact_address = transient_registration.build_contact_address(permitted_attributes)

      prefill_contact_address_params
    end

    def saved_address_still_valid?
      return false unless contact_address
      return true if postcode.blank?
      return true if postcode == contact_address.postcode

      false
    end

    def prefill_contact_address_params
      return unless contact_address

      self.premises = contact_address.premises&.strip
      self.street_address = contact_address.street_address&.strip
      self.locality = contact_address.locality&.strip
      self.city = contact_address.city&.strip
      self.postcode = contact_address.postcode&.strip
    end
  end
end
