# frozen_string_literal: true

module WasteExemptionsEngine
  class StartFormsController < FormsController
    def new
      super(StartForm, "start_form")
    end

    def create
      super(StartForm, "start_form")
    end

    private

    def transient_registration_attributes
      params.require(:start_form).permit(:start_option)
    end
  end
end
