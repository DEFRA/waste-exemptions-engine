# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactNameFormsController < FormsController
    def new
      super(ContactNameForm, "contact_name_form")
    end

    def create
      super(ContactNameForm, "contact_name_form")
    end

    private

    def transient_registration_attributes
      params.require(:contact_name_form).permit(:contact_first_name, :contact_last_name)
    end
  end
end
