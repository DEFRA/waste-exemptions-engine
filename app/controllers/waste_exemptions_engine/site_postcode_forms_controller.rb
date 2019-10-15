# frozen_string_literal: true

module WasteExemptionsEngine
  class SitePostcodeFormsController < PostcodeFormsController
    def new
      super(SitePostcodeForm, "site_postcode_form")
    end

    def create
      super(SitePostcodeForm, "site_postcode_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:site_postcode_form, {}).permit(:temp_site_postcode)
    end
  end
end
