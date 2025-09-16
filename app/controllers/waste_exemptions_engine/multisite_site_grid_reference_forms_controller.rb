# frozen_string_literal: true

module WasteExemptionsEngine
  class MultisiteSiteGridReferenceFormsController < FormsController
    def new
      super(MultisiteSiteGridReferenceForm, "multisite_site_grid_reference_form")
    end

    def create
      super(MultisiteSiteGridReferenceForm, "multisite_site_grid_reference_form")
    end

    def skip_to_address
      find_or_initialize_registration(params[:token])

      @transient_registration.skip_to_address if form_matches_state?
      redirect_to_correct_form
    end

    private

    def transient_registration_attributes
      params
        .fetch(:multisite_site_grid_reference_form, {})
        .permit(:description, :grid_reference)
    end
  end
end
