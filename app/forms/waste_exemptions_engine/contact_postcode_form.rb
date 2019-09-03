# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPostcodeForm < BasePostcodeForm
    attr_accessor :business_type, :temp_contact_postcode

    validates :temp_contact_postcode, "waste_exemptions_engine/postcode": true

    def initialize(registration)
      super

      # We only use this for the correct microcopy
      self.business_type = @transient_registration.business_type
      self.temp_contact_postcode = @transient_registration.temp_contact_postcode
    end

    def submit(params)
      self.temp_contact_postcode = format_postcode(params[:temp_contact_postcode])
      
      # We persist the postcode regardless of validations.
      transient_registration.update_attributes(temp_contact_postcode: temp_contact_postcode)
      
      super({})
    end
  end
end
