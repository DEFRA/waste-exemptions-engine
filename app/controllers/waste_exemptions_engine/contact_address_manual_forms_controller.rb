# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactAddressManualFormsController < FormsController
    def new
      super(ContactAddressManualForm, "contact_address_manual_form")
    end

    def create
      super(ContactAddressManualForm, "contact_address_manual_form")
    end

    private

    def transient_registration_attributes
      params
        .fetch(:contact_address_manual_form, {})
        .permit(contact_address: %i[locality postcode city premises street_address mode])
    end
  end
end
