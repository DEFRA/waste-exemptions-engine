# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteAddressManualForm < BaseForm
    include CanClearAddressFinderError

    delegate :site_address, to: :transient_registration
    delegate :premises, :street_address, :locality, :postcode, :city, to: :site_address, allow_nil: true

    attr_accessor :postcode

    validates :site_address, "waste_exemptions_engine/manual_address": true

    after_initialize :setup_postcode

    def submit(params)
      super(site_address_attributes: params[:site_address] || {})
    end

    private

    def setup_postcode
      self.postcode = transient_registration.temp_contact_postcode

      # Prefill the existing address unless the postcode has changed from the existing address's postcode
      transient_registration.site_address = nil unless saved_address_still_valid?
    end

    def saved_address_still_valid?
      postcode == site_address&.postcode
    end
  end
end
