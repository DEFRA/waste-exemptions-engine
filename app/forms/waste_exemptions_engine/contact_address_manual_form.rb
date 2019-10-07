# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactAddressManualForm < BaseForm
    attr_accessor :address_finder_error, :postcode
    delegate :contact_address, to: :transient_registration
    delegate :premises, :street_address, :locality, :postcode, :city, to: :contact_address, allow_nil: true

    validates :contact_address, "waste_exemptions_engine/manual_address": true

    after_initialize :setup_postcode

    def submit(params)
      permitted_attributes = params.require(:contact_address)
      permitted_attributes = permitted_attributes.permit(:locality, :postcode, :city, :premises, :street_address, :mode)

      super(contact_address_attributes: permitted_attributes)
    end

    private

    def setup_postcode
      self.postcode = transient_registration.temp_contact_postcode

      # Check if the user reached this page through an Address finder error.
      # Then wipe the temp attribute as we only need it for routing
      self.address_finder_error = transient_registration.address_finder_error
      transient_registration.update_attributes(address_finder_error: nil)

      # Prefill the existing address unless the postcode has changed from the existing address's postcode
      transient_registration.contact_address = nil unless saved_address_still_valid?
    end

    def saved_address_still_valid?
      return true if postcode.blank?

      postcode == contact_address.postcode
    end
  end
end
