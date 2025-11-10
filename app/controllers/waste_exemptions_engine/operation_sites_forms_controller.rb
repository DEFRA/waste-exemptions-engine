# frozen_string_literal: true

module WasteExemptionsEngine
  class OperationSitesFormsController < FormsController
    def new
      super(OperationSitesForm, "operation_sites_form")
      @page = params[:page] || 1
    end

    def create
      super(OperationSitesForm, "operation_sites_form")
    end

    def edit
      return unless set_up_form(SiteGridReferenceForm, "site_grid_reference_form", params[:token], get_request: false)

      @page = params[:page]
      @site_address = find_site_address(params[:site_id])

      @site_grid_reference_form.assign_existing_site(@site_address)
      configure_edit_form_options(@site_address)

      render "waste_exemptions_engine/site_grid_reference_forms/new"
    end

    def update
      return unless set_up_form(SiteGridReferenceForm, "site_grid_reference_form", params[:token])

      @page = params[:page]
      @site_address = find_site_address(params[:site_id])

      @site_grid_reference_form.assign_existing_site(@site_address)

      if @site_grid_reference_form.submit(site_grid_reference_params)
        redirect_to new_operation_sites_form_path(@transient_registration.token, page: @page)
      else
        configure_edit_form_options(@site_address)
        render "waste_exemptions_engine/site_grid_reference_forms/new", status: :unprocessable_entity
      end
    end

    private

    def find_site_address(site_id)
      address = @transient_registration.transient_addresses.find_by(id: site_id)
      raise ActionController::RoutingError, "Not Found" unless address.present? && address.site?

      address
    end

    def site_grid_reference_params
      params
        .fetch(:site_grid_reference_form, {})
        .permit(:grid_reference, :description)
    end

    def configure_edit_form_options(site_address)
      @form_url = update_operation_sites_forms_path(token: @transient_registration.token,
                                                    site_id: site_address.id,
                                                    page: @page)
      @form_method = :post
      @allow_skip_to_postcode = false
    end

    def transient_registration_attributes
      params.fetch(:operation_sites_form, {}).permit
    end
  end
end
