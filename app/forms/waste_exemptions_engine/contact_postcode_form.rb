# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPostcodeForm < BasePostcodeForm
    delegate :business_type, :temp_contact_postcode, to: :transient_registration

    validates :temp_contact_postcode, "waste_exemptions_engine/postcode": true

    def submit(params)
      params[:temp_contact_postcode] = format_postcode(params[:temp_contact_postcode])

      # We persist the postcode regardless of validations.
      transient_registration.update_attributes(params)

      super({})
    end
  end
end
