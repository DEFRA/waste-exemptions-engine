# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactAgencyForm < BaseForm
    include CanNavigateFlexibly

    def initialize(enrollment)
      super
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      attributes = {}

      super(attributes, params[:id])
    end
  end
end
