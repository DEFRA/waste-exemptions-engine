# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPostcodeForm < PostcodeForm
    include CanNavigateFlexibly

    private

    def existing_postcode
      @registration.interim.contact_postcode
    end
  end
end
