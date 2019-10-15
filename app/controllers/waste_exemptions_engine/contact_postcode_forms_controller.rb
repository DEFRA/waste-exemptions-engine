# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPostcodeFormsController < PostcodeFormsController
    def new
      super(ContactPostcodeForm, "contact_postcode_form")
    end

    def create
      super(ContactPostcodeForm, "contact_postcode_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:contact_postcode_form, {}).permit(:temp_contact_postcode)
    end
  end
end
