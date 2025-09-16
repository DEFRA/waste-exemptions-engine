# frozen_string_literal: true

module WasteExemptionsEngine
  class MultisiteSitePostcodeFormsController < FormsController
    def new
      super(MultisiteSitePostcodeForm, "multisite_site_postcode_form")

      # Clear out any previously entered postcode
      @transient_registration.update(temp_site_postcode: nil)
    end

    def create
      super(MultisiteSitePostcodeForm, "multisite_site_postcode_form")
    end

    private

    def transient_registration_attributes
      params
        .fetch(:multisite_site_postcode_form, {})
        .permit(:temp_site_postcode)
    end
  end
end
