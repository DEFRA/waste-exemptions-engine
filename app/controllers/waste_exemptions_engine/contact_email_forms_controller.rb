# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactEmailFormsController < FormsController
    def new
      super(ContactEmailForm, "contact_email_form")
    end

    def create
      super(ContactEmailForm, "contact_email_form")
    end
  end
end
