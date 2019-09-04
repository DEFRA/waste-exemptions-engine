# frozen_string_literal: true

module WasteExemptionsEngine
  class SitePostcodeForm < BasePostcodeForm
    attr_accessor :business_type, :temp_site_postcode

    validates :temp_site_postcode, "waste_exemptions_engine/postcode": true

    def initialize(registration)
      super

      # We only use this for the correct microcopy
      self.business_type = @transient_registration.business_type
      self.temp_site_postcode = @transient_registration.temp_site_postcode
    end

    def submit(params)
      self.temp_site_postcode = format_postcode(params[:temp_site_postcode])

      # We persist the postcode regardless of validations.
      transient_registration.update_attributes(temp_site_postcode: temp_site_postcode)

      super({})
    end
  end
end
