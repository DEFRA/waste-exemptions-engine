# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactAddressManualFormsController < FormsController
    def new
      super(ContactAddressManualForm, "contact_address_manual_form")
    end

    def create
      super(ContactAddressManualForm, "contact_address_manual_form")
    end
  end
end
