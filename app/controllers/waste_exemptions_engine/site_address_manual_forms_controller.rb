# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteAddressManualFormsController < FormsController
    def new
      super(SiteAddressManualForm, "site_address_manual_form")
    end

    def create
      super(SiteAddressManualForm, "site_address_manual_form")
    end

    private

    def transient_registration_attributes
      params
        .require(:site_address_manual_form)
        .permit(site_address: %i[locality postcode city premises street_address mode])
    end
  end
end
