# frozen_string_literal: true

module WasteExemptionsEngine
  class SitesFormsController < FormsController
    include CanRedirectSitesFormToLastPage

    def new
      super(SitesForm, "sites_form")
      return unless @sites_form

      @page = @sites_form.page_to_display(params[:page])
    end

    def create
      super(SitesForm, "sites_form")
    end

    def remove_site
      return unless set_up_form(SitesForm, "sites_form", params[:token])

      @transient_registration.addresses.find_by(address_type: "site", id: params[:site_id])&.destroy

      redirect_to_correct_form
    end

    private

    def transient_registration_attributes
      params.fetch(:sites_form, {}).permit
    end
  end
end
