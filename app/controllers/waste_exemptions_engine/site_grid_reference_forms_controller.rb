# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteGridReferenceFormsController < FormsController
    def new
      super(SiteGridReferenceForm, "site_grid_reference_form")
    end

    def create
      super(SiteGridReferenceForm, "site_grid_reference_form")
    end

    def skip_to_address
      find_or_initialize_registration(params[:token])

      @transient_registration.skip_to_address if form_matches_state?
      redirect_to_correct_form
    end

    private

    def transient_registration_attributes
      params
        .fetch(:site_grid_reference_form, {})
        .permit(:description, :grid_reference, :is_legacy_linear)
    end
  end
end
