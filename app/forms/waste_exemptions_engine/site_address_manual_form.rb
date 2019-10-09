# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteAddressManualForm < BaseForm
    include CanClearAddressFinderError

    attr_accessor :postcode

    delegate :site_address, to: :transient_registration
    delegate :premises, :street_address, :locality, :postcode, :city, to: :site_address, allow_nil: true

    validates :site_address, "waste_exemptions_engine/manual_address": true

    after_initialize :setup_postcode

    def submit(params)
      permitted_attributes = params.require(:site_address)
      permitted_attributes = permitted_attributes.permit(:locality, :postcode, :city, :premises, :street_address, :mode)

      super(site_address_attributes: permitted_attributes)
    end

    private

    def setup_postcode
      self.postcode = transient_registration.temp_contact_postcode

      # Prefill the existing address unless the postcode has changed from the existing address's postcode
      transient_registration.site_address = nil unless saved_address_still_valid?
    end

    def saved_address_still_valid?
      return true if postcode.blank?

      postcode == site_address.postcode
    end
  end
end
