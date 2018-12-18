# frozen_string_literal: true

module WasteExemptionsEngine
  class AddressFormsController < FormsController
    def skip_to_manual_address
      find_or_initialize_enrollment(params[:token])

      @enrollment.skip_to_manual_address! if form_matches_state?
      redirect_to_correct_form
    end
  end
end
