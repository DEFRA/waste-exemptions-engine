# frozen_string_literal: true

module WasteExemptionsEngine
  class LocationFormsController < FormsController
    def new
      super(LocationForm, "location_form")
    end

    def create
      super(LocationForm, "location_form")
    end
  end
end
