# frozen_string_literal: true

module WasteExemptionsEngine
  class MultipleSitesFormsController < FormsController
    def new
      super(MultipleSitesForm, "multiple_sites_form")
      @page = params[:page] || 1
    end

    def create
      super(MultipleSitesForm, "multiple_sites_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:multiple_sites_form, {}).permit
    end
  end
end
