# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteAddressManualFormsController < FormsController
    def new
      super(SiteAddressManualForm, "site_address_manual_form")
    end

    def create
      super(SiteAddressManualForm, "site_address_manual_form")
    end
  end
end
