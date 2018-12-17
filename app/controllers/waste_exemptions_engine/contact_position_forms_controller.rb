# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPositionFormsController < FormsController
    def new
      super(ContactPositionForm, "contact_position_form")
    end

    def create
      super(ContactPositionForm, "contact_position_form")
    end
  end
end
