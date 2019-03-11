# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPostcodeForm < PostcodeForm
    include CanNavigateFlexibly

    private

    def existing_postcode
      @transient_registration.temp_contact_postcode
    end
  end
end
