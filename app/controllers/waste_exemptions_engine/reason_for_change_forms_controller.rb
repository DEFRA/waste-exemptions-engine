# frozen_string_literal: true

module WasteExemptionsEngine
  class ReasonForChangeFormsController < FormsController
    include EditPermissionChecks

    def new
      super(ReasonForChangeForm, "reason_for_change_form")
    end

    def create
      super(ReasonForChangeForm, "reason_for_change_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:reason_for_change_form, {}).permit(:reason_for_change)
    end
  end
end
