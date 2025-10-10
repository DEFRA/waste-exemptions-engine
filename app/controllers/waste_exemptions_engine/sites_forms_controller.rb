# frozen_string_literal: true

module WasteExemptionsEngine
  class SitesFormsController < FormsController
    def new
      super(SitesForm, "sites_form")
      @page = params[:page] || 1
    end

    def create
      super(SitesForm, "sites_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:sites_form, {}).permit
    end
  end
end
