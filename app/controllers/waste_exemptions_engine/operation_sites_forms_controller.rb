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

    def edit_site
      find_or_initialize_registration(params[:token])
      address = find_site_address(params[:site_id])

      if address.present?
        @transient_registration.update(temp_site_id: params[:site_id])
        @transient_registration.edit_site if form_matches_state?
      end

      redirect_to_correct_form
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

    def transient_registration_attributes
      params.fetch(:operation_sites_form, {}).permit
    end
  end
end
