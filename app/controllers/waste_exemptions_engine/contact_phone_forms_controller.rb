# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPhoneFormsController < FormsController
    def new
      super(ContactPhoneForm, "contact_phone_form")
    end

    def create
      super(ContactPhoneForm, "contact_phone_form")
    end

    private

    def transient_registration_attributes
      params.require(:contact_phone_form).permit(:contact_phone)
    end
  end
end
