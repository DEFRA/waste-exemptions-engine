# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactEmailFormsController < FormsController
    def new
      super(ContactEmailForm, "contact_email_form")
    end

    def create
      super(ContactEmailForm, "contact_email_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:contact_email_form, {}).permit(:confirmed_email, :contact_email, :no_email_address)
    end
  end
end
