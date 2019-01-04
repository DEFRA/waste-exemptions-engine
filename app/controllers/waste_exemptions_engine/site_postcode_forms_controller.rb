# frozen_string_literal: true

module WasteExemptionsEngine
  class SitePostcodeFormsController < PostcodeFormsController
    def new
      super(SitePostcodeForm, "site_postcode_form")
    end

    def create
      super(SitePostcodeForm, "site_postcode_form")
    end
  end
end
