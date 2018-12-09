# frozen_string_literal: true

module WasteExemptionsEngine
  class StartFormsController < FormsController
    def new
      super(StartForm, "start_form")
    end

    def create
      super(StartForm, "start_form")
    end
  end
end
