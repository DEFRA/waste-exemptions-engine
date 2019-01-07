# frozen_string_literal: true

module WasteExemptionsEngine
  class RegisterInWalesForm < BaseForm
    include CanNavigateFlexibly

    def initialize(registration)
      super
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      attributes = {}

      super(attributes, params[:token])
    end
  end
end
