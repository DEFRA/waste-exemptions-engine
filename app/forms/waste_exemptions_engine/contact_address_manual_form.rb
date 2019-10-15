# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactAddressManualForm < BaseForm
    include CanClearAddressFinderError

    delegate :contact_address, to: :transient_registration
    delegate :premises, :street_address, :locality, :postcode, :city, to: :contact_address, allow_nil: true

    attr_accessor :postcode

    validates :contact_address, "waste_exemptions_engine/manual_address": true

    after_initialize :setup_postcode

    def submit(params)
      super(contact_address_attributes: params[:contact_address])
    end

    private

    def setup_postcode
      self.postcode = transient_registration.temp_contact_postcode

      # Prefill the existing address unless the postcode has changed from the existing address's postcode
      transient_registration.contact_address = nil unless saved_address_still_valid?
    end

    def saved_address_still_valid?
      postcode == contact_address&.postcode
    end
  end
end
