# frozen_string_literal: true

module WasteExemptionsEngine
  class CaptureReferenceFormsController < FormsController
    def new
      super(CaptureReferenceForm, "capture_reference_form")
    end

    def create
      return false unless set_up_form(CaptureReferenceForm, "capture_reference_form", params[:token])

      super(CaptureReferenceForm, "capture_reference_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:capture_reference_form, {}).permit(:reference)
    end
  end
end
