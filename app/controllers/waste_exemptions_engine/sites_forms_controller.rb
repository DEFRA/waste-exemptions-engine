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

    def remove_site
      return unless set_up_form(SitesForm, "sites_form", params[:token])

      @transient_registration.addresses.find_by(address_type: "site", id: params[:site_id])&.destroy

      redirect_to new_sites_form_path(@sites_form.token, page: params[:page])
    end

    private

    def transient_registration_attributes
      params.fetch(:sites_form, {}).permit
    end
  end
end
