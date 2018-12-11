# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactAgencyFormsController < FormsController
    def new
      super(ContactAgencyForm, "contact_agency_form")
    end

    def create
      super(ContactAgencyForm, "contact_agency_form")
    end
  end
end
