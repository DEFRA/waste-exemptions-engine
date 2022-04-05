# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckSiteAddressFormsController < FormsController
    def new
      super(CheckSiteAddressForm, "check_site_address_form")
    end

    def create
      super(CheckSiteAddressForm, "check_site_address_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:check_site_address_form, {}).permit(:temp_reuse_address)
    end
  end
end
