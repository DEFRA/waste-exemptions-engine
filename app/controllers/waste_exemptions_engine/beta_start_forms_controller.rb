# frozen_string_literal: true

module WasteExemptionsEngine
  class BetaStartFormsController < FormsController
    def new
      super(BetaStartForm, "beta_start_form")
    end

    def create
      super(BetaStartForm, "beta_start_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:beta_start_form, {}).permit(:beta_start_option)
    end

    def find_or_initialize_registration(token)
      @transient_registration = TransientRegistration.find_by(
        token: token
      ) || NewChargedRegistration.new
    end
  end
end
