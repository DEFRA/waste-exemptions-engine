# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPositionFormsController < FormsController
    def new
      super(ContactPositionForm, "contact_position_form")
    end

    def create
      super(ContactPositionForm, "contact_position_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:contact_position_form, {}).permit(:contact_position)
    end
  end
end
